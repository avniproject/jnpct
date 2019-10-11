const rulesConfigInfra = require('rules-config/infra');
const IDI = require('openchs-idi');

module.exports = IDI.configure({
    "name": "jnpct",
    "chs-admin": "admin",
    "org-name": "JNPCT",
    "org-admin": "admin@jnpct",
    "secrets": '../secrets.json',
    "files": {
        "adminUsers": {
            "dev": ["users/admin-user.json"],
        },
        "forms": [
            "registration/registrationForm.json",
            "eligibleCouple/eligibleCoupleEnrolmentForm.json",
            "eligibleCouple/eligibleCoupleFollowupForm.json",
            "pregnancy/pregnancyEnrolmentForm.json",
            "pregnancy/ancForm.json",
        ],
        "formMappings": [
            "metadata/formMappings.json"
        ],
        "formDeletions": [
        ],
        "formAdditions": [
        ],
        "catchments": [
            "metadata/catchments.json"
        ],
        "checklistDetails": [
        ],
        "concepts": [
            "registration/registrationConcepts.json",
             "eligibleCouple/eligibleCoupleConcepts.json",
             "pregnancy/pregnancyEnrolmentConcepts.json",
             "pregnancy/ancFormConcepts.json"
        ],
        "locations": [
            "metadata/locations.json"
        ],
        "programs": ["programs.json"],
        "encounterTypes": [
            "metadata/encounterTypes.json"
        ],
        "operationalEncounterTypes": [
            "metadata/operationalEncounterTypes.json"
        ],
        "operationalPrograms": [
            "metadata/operationalPrograms.json"
        ],
        "subjectTypes": ["subjectTypes.json"],
        "operationalSubjectTypes": [
            "metadata/operationalSubjectTypes.json"
        ],
        "users": {
            "dev": ["users/dev-users.json"]
        },
        "rules": [
            "./rules.js"
        ],
        "organisationSql": [
            /* "create_organisation.sql"*/
        ]
    }
}, rulesConfigInfra);