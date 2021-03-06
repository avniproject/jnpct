const _ = require("lodash");
import {
    RuleFactory,
    complicationsBuilder as ComplicationsBuilder,
} from "rules-config/rules";


const followupDecision = RuleFactory("4548364c-ff22-447b-baec-3c63935a7e00", "Decision");
const followupDecisionClusterIncharge = RuleFactory("80f09382-c97b-4850-9c9e-b834e0a6f501", "Decision");


const zScoreGradeStatusMappingWeightForAge = {
    '1': 'Normal',
    '2': 'Moderately Underweight',
    '3': 'Severely Underweight'
};

const zScoreGradeStatusMappingHeightForAge = {
    '1': 'Normal',
    '2': 'Stunted',
    '3': 'Severely stunted'
};

//ordered map
//KEY:status, value: max z-score for the particular status

// const zScoreGradeStatusMappingWeightForHeight = [
//     ["Severely wasted", -3],
//     ["Wasted", -2],
//     ["Normal", 1],
//     ["Possible risk of overweight", 2],
//     ["Overweight", 3],
//     ["Obese", Infinity],
// ];

const zScoreGradeStatusMappingWeightForHeight = [
    ["SAM", -3],
    ["MAM", -2],
    ["Normal", 1],
    ["Normal", 2],
    ["Normal", 3],
    ["Normal", Infinity],
];

const weightForHeightStatus = function (zScore) {
    let found = _.find(zScoreGradeStatusMappingWeightForHeight, function (currentStatus) {
        return zScore <= currentStatus[1];
    });
    return found && found[0];
};

const getGradeforZscore = (zScore) => {
    let grade;
    if (zScore <= -3) {
        grade = 3;
    } else if (zScore > -3 && zScore < -2) {
        grade = 2;
    } else if (zScore >= -2) {
        grade = 1;
    }

    return grade;

};

const nutritionalStatusForChild = (individual, asOnDate, weight, height) => {

    const zScoresForChild = ruleServiceLibraryInterfaceForSharingModules.common.getZScore(individual, asOnDate, weight, height);

    console.log('zScoresForChild', zScoresForChild);

    const wfaGrade = getGradeforZscore(zScoresForChild.wfa);
    const wfaStatus = zScoreGradeStatusMappingWeightForAge[wfaGrade];

    const hfaGrade = getGradeforZscore(zScoresForChild.hfa);
    const hfaStatus = zScoreGradeStatusMappingHeightForAge[hfaGrade];

    const wfhStatus = weightForHeightStatus(zScoresForChild.wfh);

    return {
        wfa: zScoresForChild.wfa,
        wfaGrade: wfaGrade,
        wfaStatus: wfaStatus,
        hfa: zScoresForChild.hfa,
        hfaGrade: hfaGrade,
        hfaStatus: hfaStatus,
        wfh: zScoresForChild.wfh,
        wfhStatus: wfhStatus
    }
};

const addIfRequired = (decisions, name, value) => {
    if (value === -0) value = 0;
    if (value !== undefined) decisions.push({name: name, value: value});
};

@followupDecision("39021909-fad8-49c1-9892-2c266b08a752", "Follow Up Decision", 100)
class FollowDecisions {
    static exec(programEncounter, decisions, context, today) {

        FollowDecisions.followupDecisions(programEncounter, decisions, context, today);
        return decisions;
    }
    static followupDecisions = (programEncounter, decisions, context, today) => {
        const weight = programEncounter.getObservationValue("Weight");
        const height = programEncounter.getObservationValue("Height");
        const encounterDateTime = programEncounter.encounterDateTime;
        const individual = programEncounter.programEnrolment.individual;

        const nutritionalStatus = nutritionalStatusForChild(individual, encounterDateTime, weight, height);

        console.log('nutritionalStatus decisions', nutritionalStatus);

        addIfRequired(decisions.encounterDecisions, "Weight for age z-score", nutritionalStatus.wfa);
        addIfRequired(decisions.encounterDecisions, "Weight for age Grade", nutritionalStatus.wfaGrade);
        addIfRequired(decisions.encounterDecisions, "Weight for age Status", nutritionalStatus.wfaStatus ? [nutritionalStatus.wfaStatus] : []);

        addIfRequired(decisions.encounterDecisions, "Weight for height z-score", nutritionalStatus.wfh);
        addIfRequired(decisions.encounterDecisions, "Weight for Height Status", nutritionalStatus.wfhStatus ? [nutritionalStatus.wfhStatus] : []);

        decisions.encounterDecisions.push(FollowDecisions.referToHospital(programEncounter));
        return decisions;
    };

    static referToHospital = (programEncounter) => {
        const decisionBuilder = new ComplicationsBuilder({
            programEncounter: programEncounter,
            complicationsConcept: "Refer to the hospital for"
        });

        const age = programEncounter.programEnrolment.individual.getAgeInMonths();


        decisionBuilder.addComplication("Not able to drink or breastfeed")
            .when.valueInEncounter("Is the child able to drink or breastfeed").is.no;
        decisionBuilder.addComplication("Child Vomiting everything")
            .when.valueInEncounter("Does the child vomits everything").is.yes;
        decisionBuilder.addComplication("child had convulsion")
            .when.valueInEncounter("Has the child had convulsion").is.yes;
        decisionBuilder.addComplication("child is lethargic or unconsious")
            .when.valueInEncounter("See the child is lethargic or unconsious").is.yes;
        decisionBuilder.addComplication("there is general danger sign")
            .when.valueInEncounter("Is there general danger sign").is.yes;
        decisionBuilder.addComplication("Fast breathing")
            .when.valueInEncounter("Does the child has fast breathing").is.yes;
        decisionBuilder.addComplication("chest indrwaning")
            .when.valueInEncounter("look for chest indrwaning").is.yes;
        decisionBuilder.addComplication("child has complaint")
            .when.valueInEncounter("does child has any other complaint").is.yes;

        
        decisionBuilder.addComplication("High respiratory rate")
            .when.valueInEncounter("Child Respiratory Rate")
            .is.greaterThan(50).and.whenItem(age < 13).is.truthy
            .and.whenItem(age > 2).is.truthy;

        decisionBuilder.addComplication("High respiratory rate")
            .when.valueInEncounter("Child Respiratory Rate")
            .is.greaterThan(40).and.whenItem(age > 12).is.truthy;

        decisionBuilder.addComplication("High respiratory rate")
            .when.valueInEncounter("Child Respiratory Rate")
            .is.greaterThan(60).and.whenItem(age < 2).is.truthy;

        return decisionBuilder.getComplications();

    }
}

@followupDecisionClusterIncharge("0b3a820e-369f-4a7a-a54b-bc44ef13a31e", "Follow Up Decision Cluster Incharge", 100)
class FollowDecisionsClusterIncharge {
    static exec(programEncounter, decisions, context, today) {
        FollowDecisionsClusterIncharge.followupDecisions(programEncounter, decisions, context, today);
        return decisions;
    }

    static followupDecisions = (programEncounter, decisions, context, today) => {
        const weight = programEncounter.getObservationValue("Weight");
        const height = programEncounter.getObservationValue("Height");
        const encounterDateTime = programEncounter.encounterDateTime;
        const individual = programEncounter.programEnrolment.individual;

        const nutritionalStatus = nutritionalStatusForChild(individual, encounterDateTime, weight, height);

        console.log('nutritionalStatus decisions', nutritionalStatus);

        addIfRequired(decisions.encounterDecisions, "Weight for age z-score", nutritionalStatus.wfa);
        addIfRequired(decisions.encounterDecisions, "Weight for age Grade", nutritionalStatus.wfaGrade);
        addIfRequired(decisions.encounterDecisions, "Weight for age Status", nutritionalStatus.wfaStatus ? [nutritionalStatus.wfaStatus] : []);

        addIfRequired(decisions.encounterDecisions, "Weight for height z-score", nutritionalStatus.wfh);
        addIfRequired(decisions.encounterDecisions, "Weight for Height Status", nutritionalStatus.wfhStatus ? [nutritionalStatus.wfhStatus] : []);

        console.log('decisions', decisions);
        decisions.encounterDecisions.push(FollowDecisionsClusterIncharge.referToHospital(programEncounter));
        console.log('decisions', decisions);
        return decisions;
    };

    static referToHospital = (programEncounter) => {
        const decisionBuilder = new ComplicationsBuilder({
            programEncounter: programEncounter,
            complicationsConcept: "Refer to the hospital for"
        });

        const age = programEncounter.programEnrolment.individual.getAgeInMonths();


        decisionBuilder.addComplication("Not able to drink or breastfeed")
            .when.valueInEncounter("Is the child able to drink or breastfeed").is.no;
        decisionBuilder.addComplication("Child Vomiting everything")
            .when.valueInEncounter("Does the child vomits everything").is.yes;
        decisionBuilder.addComplication("child had convulsion")
            .when.valueInEncounter("Has the child had convulsion").is.yes;
        decisionBuilder.addComplication("child is lethargic or unconsious")
            .when.valueInEncounter("See the child is lethargic or unconsious").is.yes;
        decisionBuilder.addComplication("there is general danger sign")
            .when.valueInEncounter("Is there general danger sign").is.yes;
        decisionBuilder.addComplication("Fast breathing")
            .when.valueInEncounter("Does the child has fast breathing").is.yes;
        decisionBuilder.addComplication("chest indrwaning")
            .when.valueInEncounter("look for chest indrwaning").is.yes;
        decisionBuilder.addComplication("child has complaint")
            .when.valueInEncounter("does child has any other complaint").is.yes;

        decisionBuilder.addComplication("High respiratory rate")
            .when.valueInEncounter("Child Respiratory Rate")
            .is.greaterThan(50).and.whenItem(age < 13).is.truthy
            .and.whenItem(age > 2).is.truthy;

        decisionBuilder.addComplication("High respiratory rate")
            .when.valueInEncounter("Child Respiratory Rate")
            .is.greaterThan(40).and.whenItem(age > 12).is.truthy;

        decisionBuilder.addComplication("High respiratory rate")
            .when.valueInEncounter("Child Respiratory Rate")
            .is.greaterThan(60).and.whenItem(age < 2).is.truthy;
    

        return decisionBuilder.getComplications();

    }
}


module.exports = {FollowDecisions, FollowDecisionsClusterIncharge};