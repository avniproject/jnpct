const moment = require("moment");
const _ = require("lodash");
import {
    FormElementsStatusHelper,
    FormElementStatus,
    RuleCondition,
    RuleFactory,
    StatusBuilderAnnotationFactory,
    complicationsBuilder as ComplicationsBuilder,
    WithName
} from 'rules-config/rules';
import lib from '../lib';

const AncFormViewFilterClusterIncharge = RuleFactory("ac8f3477-6841-4a22-99fe-8467b0e311d0", "ViewFilter");
const WithStatusBuilder = StatusBuilderAnnotationFactory('programEncounter', 'formElement');
const ancDecisionClusterIncharge = RuleFactory("ac8f3477-6841-4a22-99fe-8467b0e311d0", "Decision");

const getCurrentWeek = (programEncounter) => {
    const lmpDate = programEncounter.programEnrolment.getObservationValue('Last menstrual period');
    return (Math.round(moment(programEncounter.encounterDateTime).diff(lmpDate, 'weeks', true)));
}

const getCurrentTrimester = (programEncounter) => {
    const currentTrimester = lib.calculations.currentTrimester(programEncounter.programEnrolment, programEncounter.encounterDateTime);
    return currentTrimester;
}

const isAbnormalWeightGain = (programEncounter) => {
    const {programEnrolment, encounterDateTime} = programEncounter;
    return !lib.calculations.isNormalWeightGain(programEnrolment, programEncounter, encounterDateTime);
};

@AncFormViewFilterClusterIncharge("9f927a89-bc5d-4808-9b7b-8ab6e0b2768e", "JNPCT Anc Form View Filter Cluster Incahrge", 100.0, {})
class PregnancyAncFormViewFilterHandlerClusterIncharge {
    static exec(programEncounter, formElementGroup, today) {
        return FormElementsStatusHelper
            .getFormElementsStatusesWithoutDefaults(new PregnancyAncFormViewFilterHandlerClusterIncharge(), programEncounter, formElementGroup, today);

    }

    @WithName("Mamta card")
    @WithStatusBuilder
    a1([], statusBuilder) {
        statusBuilder.show().when.latestValueInPreviousEncounters('Mamta card').is.notDefined
            .or.containsAnswerConceptName("No");
    }

    @WithName("Does she eat all the snacks")
    @WithStatusBuilder
    ab2([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Does she get snacks from Anganwadi")
            .containsAnswerConceptName('Yes');
    }

    @WithName("IF YES THEN WRITE NUMBER OF TABLET SWALLOWED")
    @WithStatusBuilder
    a2([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Is she taking iron/folic acid tablet?").is.yes;
    }

    @WithName("IF YES THEN WRITE NUMBER OF CALCIUM TABLET SWALLOWED")
    @WithStatusBuilder
    a3([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Is she taking calcium tablet?").is.yes;
    }

    @WithName("Height")
    @WithStatusBuilder
    a4([], statusBuilder) {
        // statusBuilder.show().when.valueInEncounter("Height").is.defined
        // .or.when.latestValueInPreviousEncounters("Height").is.notDefined;
        statusBuilder.show().when.latestValueInPreviousEncounters("Height").is.notDefined;
    }

    @WithName("HB measured by color scale")
    @WithStatusBuilder
    a44([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("H.B").is.notDefined;
    }

    bmi(programEncounter, formElement) {
        let weight = programEncounter.getObservationValue('Weight');
        let height = programEncounter.programEnrolment.getObservationReadableValueInEntireEnrolment('Height', programEncounter);
        let bmi = '';
        if (_.isNumber(height) && _.isNumber(weight)) {
            bmi = lib.C.calculateBMI(weight, height);
        }
        return new FormElementStatus(formElement.uuid, true, bmi);
    }

    @WithName("IF yes then since how many days")
    @WithStatusBuilder
    a5([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("pedal oedema is present").is.yes;
    }

    @WithName("Sickle cell test  done")
    @WithStatusBuilder
    a6([], statusBuilder) {
        statusBuilder.show().when.latestValueInPreviousEncounters('Sickle cell test  done').is.notDefined
            .or.containsAnswerConceptName("No");
    }

    @WithName("IF YES, result of sickle cell test")
    @WithStatusBuilder
    a7([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Sickle cell test  done").is.yes;
    }

    @WithName("H.B")
    @WithName("Blood Sugar")
    @WithName("VDRL")
    @WithName("HIV/AIDS Test")
    @WithName("HbsAg")
    @WithName("Blood Examination Date")
    @WithName("Urine Albumin")
    @WithName("Urine Sugar")
    @WithStatusBuilder
    a8888([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Is laboratory test done?").is.yes;
    }

    @WithName("If YES then write E.D.D as per USG")
    @WithStatusBuilder
    a8([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Complete hospital checkup done").is.yes
            .and.when.latestValueInPreviousEncounters("If YES then write E.D.D as per USG").is.notDefined;
    }

    @WithName("USG Scanning Report - Number of foetus")
    @WithStatusBuilder
    a10([], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("USG Scanning Report - Number of foetus").is.defined
            .or.when.latestValueInPreviousEncounters("USG Scanning Report - Number of foetus").is.notDefined
            .and.when.valueInEncounter("Complete hospital checkup done").is.yes;
        return statusBuilder.build();
    }

    @WithName("USG Scanning Report - Amniotic fluid")
    @WithStatusBuilder
    a11([programEncounter], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("USG Scanning Report - Amniotic fluid").is.defined
            .or.when.latestValueInPreviousEncounters("USG Scanning Report - Amniotic fluid").is.notDefined
            .and.when.valueInEncounter("Complete hospital checkup done").is.yes;
        return statusBuilder.build();
    }

    @WithName("USG Scanning Report - Placenta Previa")
    @WithStatusBuilder
    a12([programEncounter], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("USG Scanning Report - Placenta Previa").is.defined
            .or.when.latestValueInPreviousEncounters("USG Scanning Report - Placenta Previa").is.notDefined
            .and.when.valueInEncounter("Complete hospital checkup done").is.yes;
        return statusBuilder.build();
    }

    @WithName("Foetal presentation")
    @WithStatusBuilder
    a13([programEncounter], statusBuilder) {
        statusBuilder.show().when.valueInEncounter("Foetal presentation").is.defined
            .or.when.latestValueInPreviousEncounters("Foetal presentation").is.notDefined
            .and.when.valueInEncounter("Complete hospital checkup done").is.yes;
        return statusBuilder.build();
    }


    @WithName("TD 1")
    a15(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD 1")
            .is.defined.matches()) {
            return new FormElementStatus(formElement.uuid, false);
        }

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD 1")
            .is.defined
            .and.when.latestValueInPreviousEncounters("TD 2")
            .is.defined.matches())
            return new FormElementStatus(formElement.uuid, false);

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD Booster")
            .is.defined.matches()) {
            return new FormElementStatus(formElement.uuid, false);
        }

        return new FormElementStatus(formElement.uuid, true);

    }

    @WithName("TD 2")
    a16(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD 2")
            .is.defined.matches()) {
            return new FormElementStatus(formElement.uuid, false);
        }

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD 1")
            .is.defined
            .and.when.latestValueInPreviousEncounters("TD 2")
            .is.defined.matches())
            return new FormElementStatus(formElement.uuid, false);

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD Booster")
            .is.defined.matches()) {
            return new FormElementStatus(formElement.uuid, false);
        }

        return new FormElementStatus(formElement.uuid, true);

    }

    @WithName("TD Booster")
    a17(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD 1")
            .is.defined
            .and.when.latestValueInPreviousEncounters("TD 2")
            .is.defined.matches())
            return new FormElementStatus(formElement.uuid, false);

        if (new RuleCondition(context).when.latestValueInPreviousEncounters("TD Booster")
            .is.defined.matches()) {
            return new FormElementStatus(formElement.uuid, false);
        }

        return new FormElementStatus(formElement.uuid, true);
    }

    @WithName("Blood Group")
    @WithStatusBuilder
    a18([], statusBuilder) {
        statusBuilder.show().when.latestValueInPreviousEncounters('Blood Group').is.notDefined
            .or.containsAnswerConceptName("Don't Know");
    }


    @WithName("Complete hospital checkup done")
    @WithStatusBuilder
    a31([], statusBuilder) {
        statusBuilder.show().when.latestValueInPreviousEncounters("Complete hospital checkup done")
            .is.notDefined.or.containsAnswerConceptName("No");

        // const context = {programEncounter, formElement};        
        // statusBuilder.show.whenItem(getCurrentTrimester(programEncounter)).is.equals(1)
        //  .and.when.latestValueInPreviousEncounters("Complete hospital checkup done").not.containsAnswerConceptName("Yes");

        //  if (new RuleCondition(context).whenItem(getCurrentTrimester(programEncounter)).is.equals(1)
        //         .and.when.latestValueInPreviousEncounters("Complete hospital checkup done").is.notDefined.matches()) {
        //     return new FormElementStatus(formElement.uuid, true);
        // }
        // if (new RuleCondition(context).whenItem(getCurrentTrimester(programEncounter)).is.equals(1)
        //     .and.when.latestValueInPreviousEncounters("Complete hospital checkup done")
        //     .containsAnswerConceptName("No").matches()) {
        //     return new FormElementStatus(formElement.uuid, true);
        // }
        //  return new FormElementStatus(formElement.uuid, false);
    }


    @WithName("Plan to do delivery?")
    a19(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Plan to do delivery?").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Plan to do delivery?")
            .containsAnswerConceptName("Not yet decided").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Place of delivery")
    a20(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Place of delivery").is.notDefined.matches()) {
            const status = new FormElementStatus(formElement.uuid, true);
            // status.answersToSkip = ["On the way"];
            status.answersToSkip = [formElement.getAnswerWithConceptName("On the way")];
            return status;
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Place of delivery")
            .containsAnswerConceptName("Not yet decided").matches()) {
            const status = new FormElementStatus(formElement.uuid, true);
            // status.answersToSkip = {answersToSkip};
            status.answersToSkip = [formElement.getAnswerWithConceptName("On the way")];
            return status;
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Who will be accompaning you at the time of delivery?")
    a21(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Who will be accompaning you at the time of delivery?").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Who will be accompaning you at the time of delivery?")
            .containsAnswerConceptName("Not yet decided").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("COUNSELLING FOR 108")
    a22(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("COUNSELLING FOR 108").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("COUNSELLING FOR 108")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("PLAN IN WHICH HOSPITAL")
    a23(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("PLAN IN WHICH HOSPITAL").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("PLAN IN WHICH HOSPITAL")
            .containsAnswerConceptName("Not yet decided").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("MONEY SAVED")
    a24(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("MONEY SAVED").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("MONEY SAVED")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Who will give blood if required")
    a25(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Who will give blood if required").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Who will give blood if required")
            .containsAnswerConceptName("Not yet decided").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY")
    a26(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Counselling Done for the risk factors / Morbidities to all Family members")
    a27(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Counselling Done for the risk factors / Morbidities to all Family members")
            .is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Counselling Done for the risk factors / Morbidities to all Family members")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Counselling done for the Government Scheme?")
    a28(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Counselling done for the Government Scheme?").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Counselling done for the Government Scheme?")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Chiranjivi yojna form is ready?")
    a29(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Chiranjivi yojna form is ready?").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Chiranjivi yojna form is ready?")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

    @WithName("Have you enrolled in any government scheme?")
    a30(programEncounter, formElement) {
        const context = {programEncounter, formElement};

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Have you enrolled in any government scheme?").is.notDefined.matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        if (new RuleCondition(context).whenItem(getCurrentWeek(programEncounter)).is.greaterThanOrEqualTo(21)
            .and.when.latestValueInPreviousEncounters("Have you enrolled in any government scheme?")
            .containsAnswerConceptName("No").matches()) {
            return new FormElementStatus(formElement.uuid, true);
        }

        return new FormElementStatus(formElement.uuid, false);
    }

}

@ancDecisionClusterIncharge("1414e04a-0e3d-4830-8e4c-b3b44c7f36be", "Anc Form Decision Cluster Incharge", 100.0, {})
export class AncFormDecisionClusterInchargeHandler {
    static highRisk(programEncounter) {
        const complicationsBuilder = new ComplicationsBuilder({
            programEncounter: programEncounter,
            complicationsConcept: "High Risk Conditions"
        });

        //Height is less than 145
        complicationsBuilder.addComplication("Height is less than 145")
            .when.valueInEncounter("Height").lessThanOrEqualTo(145);

        complicationsBuilder.addComplication("Irregular weight gain")
            .when.valueInEncounter("Weight").lessThanOrEqualTo(35);

        complicationsBuilder.addComplication("Irregular weight gain")
            .whenItem(isAbnormalWeightGain(programEncounter)).is.truthy;

        complicationsBuilder.addComplication('Low BMI')
            .when.valueInEncounter('BMI').lessThan(18.5);

        complicationsBuilder.addComplication('High BMI')
            .when.valueInEncounter('BMI').greaterThan(24.9);

        complicationsBuilder.addComplication("Rh Negative Blood Group")
            .when.valueInEncounter("Blood Group").containsAnyAnswerConceptName("A-", "AB-", "O-", "B-");

        complicationsBuilder.addComplication("Pedal Edema Present")
            .when.valueInEncounter("pedal oedema is present").containsAnswerConceptName("Yes");

        complicationsBuilder.addComplication("Pallor Present")
            .when.valueInEncounter("Pallor").containsAnswerConceptName("Present");

        complicationsBuilder.addComplication("Hypertension")
            .when.valueInEncounter("B.P - Systolic").greaterThanOrEqualTo(140);

        complicationsBuilder.addComplication("Hypertension")
            .when.valueInEncounter("B.P - Diastolic").greaterThanOrEqualTo(90);

        complicationsBuilder.addComplication("High Temperature")
            .when.valueInEncounter("Temperature").greaterThan(37.5);

        complicationsBuilder.addComplication("Having convulsions")
            .when.valueInEncounter("Has she been having convulsions?").containsAnswerConceptName("Present");

        complicationsBuilder.addComplication("Jaundice (Icterus)")
            .when.valueInEncounter("Jaundice (Icterus)").containsAnswerConceptName("Present");

        complicationsBuilder.addComplication("Breast Examination -Nipple not normal")
            .when.valueInEncounter("Breast Examination - Nipple").containsAnyAnswerConceptName("Retracted", "Flat");

        complicationsBuilder.addComplication("Danger sign(s) present")
            .when.valueInEncounter("Is there any danger sign")
            .containsAnyAnswerConceptName("Malaria", "eclampsia", "APH", "Foul smelling menses", "twin pregnancy",
                "fever", "difficult breathing", "severe vomiting", "problems in laboratory report",
                "Blurred vision", "Reduced fetal movement", "Other");

        complicationsBuilder.addComplication("High blood sugar")
            .when.valueInEncounter("Blood Sugar").is.greaterThanOrEqualTo(140);

        complicationsBuilder.addComplication("VDRL Postitve")
            .when.valueInEncounter("VDRL").containsAnswerConceptName("Positive");

        complicationsBuilder.addComplication("HIV/AIDS Positive")
            .when.valueInEncounter("HIV/AIDS Test").containsAnswerConceptName("Positive");

        complicationsBuilder.addComplication("HbsAg Positive")
            .when.valueInEncounter("HbsAg").containsAnswerConceptName("Positive");

        complicationsBuilder.addComplication("Sickle cell present")
            .when.valueInEncounter("IF YES, result of sickle cell test").containsAnyAnswerConceptName("DISEASE", "TRAIT");

        complicationsBuilder.addComplication("Urine Albumin present")
            .when.valueInEncounter("Urine Albumin").containsAnyAnswerConceptName("Trace", "+1", "+2", "+3", "+4");

        complicationsBuilder.addComplication("Urine Sugar present")
            .when.valueInEncounter("Urine Sugar").containsAnyAnswerConceptName("Trace", "+1", "+2", "+3", "+4");

        complicationsBuilder.addComplication("Number of foetus more than 1")
            .when.valueInEncounter("USG Scanning Report - Number of foetus").containsAnyAnswerConceptName("Two", "Three", "More than three");

        complicationsBuilder.addComplication("Liquour is not at normal level")
            .when.valueInEncounter("USG Scanning Report - Amniotic fluid").containsAnyAnswerConceptName("Increased", "Decreased");

        complicationsBuilder.addComplication("Placenta Previa present")
            .when.valueInEncounter("USG Scanning Report - Placenta Previa").containsAnyAnswerConceptName("Previa");

        complicationsBuilder.addComplication("Foetal presentation not Cephalic")
            .when.valueInEncounter("Foetal presentation").containsAnyAnswerConceptName("Transverse", "Breech");

        complicationsBuilder.addComplication("Foetal movements not normal")
            .when.valueInEncounter("Foetal movements").containsAnyAnswerConceptName("Absent", "Reduced");

        complicationsBuilder
            .addComplication("Severe Anemia")
            .when.valueInEncounter("H.B")
            .is.lessThan(7);

        complicationsBuilder
            .addComplication("Moderate Anemia")
            .when.valueInEncounter("H.B")
            .is.greaterThanOrEqualTo(7)
            .and.valueInEncounter("H.B")
            .is.lessThanOrEqualTo(9.9);

        complicationsBuilder
            .addComplication("Mild Anemia")
            .when.valueInEncounter("H.B")
            .is.greaterThanOrEqualTo(10)
            .and.valueInEncounter("H.B")
            .is.lessThanOrEqualTo(10.9);

        complicationsBuilder
            .addComplication("Severe Anemia")
            .when.valueInEncounter("HB measured by color scale")
            .is.lessThan(7);

        complicationsBuilder
            .addComplication("Moderate Anemia")
            .when.valueInEncounter("HB measured by color scale")
            .is.greaterThanOrEqualTo(7)
            .and.valueInEncounter("HB measured by color scale")
            .is.lessThanOrEqualTo(9.9);

        complicationsBuilder
            .addComplication("Mild Anemia")
            .when.valueInEncounter("HB measured by color scale")
            .is.greaterThanOrEqualTo(10)
            .and.valueInEncounter("HB measured by color scale")
            .is.lessThanOrEqualTo(10.9);


        return complicationsBuilder.getComplications();

    }

    static exec(programEncounter, decisions, context, today) {
        decisions.encounterDecisions.push(AncFormDecisionClusterInchargeHandler.highRisk(programEncounter));
        return decisions;
    }

}

module.exports = {PregnancyAncFormViewFilterHandlerClusterIncharge, AncFormDecisionClusterInchargeHandler};


