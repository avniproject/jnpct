set role jnpct_uat;

drop view if exists jnpct_pregnancy_enrolment_view;
create view jnpct_pregnancy_enrolment_view
    ("Ind.Id", "Ind.address_id", "Ind.uuid", "Ind.first_name", "Ind.last_name", "Ind.Gender",
        "Ind.date_of_birth", "Ind.date_of_birth_verified", "Ind.registration_date", "Ind.facility_id",
        "Ind.village", "Ind.subcenter", "Ind.phc", "Ind.block", "Ind.is_voided", "Enl.Program Name",
        "Enl.Id", "Enl.uuid", "Enl.is_voided", "Enl.enrolment_date_time", "Enl.program_exit_date_time",
        "Ind.Marital status", "Ind.Number of family members", "Ind.Who is decision making person in family",
        "Ind.Ration card", "Ind.Caste", "Ind.Subcaste", "Ind.Religion", "Ind.Satipati family", "Ind.Addiction",
        "Ind.Addiction - Please specify", "Ind.Very poor family", "Ind.Occupation of mother", "Ind.Occupation of husband/father",
        "Ind.Mother's education", "Ind.Mobile number", "Ind.Specialy abled", "Ind.Specially abled - Please specify",
        "Ind.Any long-term illnesses", "Ind.Long-term illness - Please specify", "Ind.Toilet facility present",
        "Ind.Using the toilet regularly", "Ind.Source of drinking water", "Enl.Last menstrual period",
        "Enl.Estimated Date of Delivery", "Enl.Previous history of disease", "Enl.Other previous history of disease - Please specify",
        "Enl.Gravida", "Enl.Number of Abortion", "Enl.Number of live childrens", "Enl.MALE", "Enl.FEMALE", "Enl.Result of last delivery",
        "Enl.Age of Youngest child", "Enl.Place of last delivery", "Enl.Risk in the last pregnancy", "Enl.what kind of risk occurred") as
WITH concepts AS (
    SELECT hstore(array_agg(c2.uuid)::text[], array_agg(c2.name)::text[]) AS map
    FROM concept
             inner join concept_answer a on concept.id = a.concept_id
             inner join concept c2 on a.answer_concept_id::integer = c2.id
    where concept.uuid in ('a20a030b-9bef-4ef8-ba8a-88e2b23c1478''f4028968-bbac-4a66-8fe7-df081321414f','8eb5a6ce-7b8a-45cc-a066-fcceca3708f7','ba25ac4c-784a-4723-8e15-a965a0d63b50','5f20070c-1cfe-4e0b-b0db-70dffee99394','b9c9d807-7064-46fd-8dc7-1640345dc8cb','4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d','0a668e5b-f3c2-4fc6-8589-d2abda26658b','e0a3086c-8d69-479e-bf44-258bc27b8105','89fe78b2-20a9-45f1-90e3-119a7bc95ce3','6f03e969-f0bf-4438-a528-5d2ce3b70e15','65a5101b-38fc-4962-876e-e0f8b9ba4cec','e42f5b28-bee4-4a01-aff0-922d823d0075',
        '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067','a154508a-9d8b-49d9-9d78-b61cbc9daf7f','d009887c-6d29-4c47-9e34-21e3b9298f44','7fa81959-a016-4569-920d-47dee242b27a','54105452-1752-4661-9d30-2d99bd2d04fa','59db93f0-0963-4e49-87b6-485efb705561','789733c4-42ba-4da3-89e6-71da227cf4c2','8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c', 'bec0e4d4-8daf-4956-8906-0f579b4cf628', '4c8e7665-30f1-4f65-b76e-b9132904ed69', '8e28efd9-7bc8-4870-929d-867ad9367962', '9b7af000-0354-4036-a7ab-1f07b43346df', '9f8e78d6-72fc-4f03-9dd9-3ec7f28639df')
)
SELECT individual.id                                                                          AS "Ind.Id",
       individual.address_id                                                                  AS "Ind.address_id",
       individual.uuid                                                                        AS "Ind.uuid",
       individual.first_name                                                                  AS "Ind.first_name",
       individual.last_name                                                                   AS "Ind.last_name",
       g.name                                                                                 AS "Ind.Gender",
       individual.date_of_birth                                                               AS "Ind.date_of_birth",
       individual.date_of_birth_verified                                                      AS "Ind.date_of_birth_verified",
       individual.registration_date                                                           AS "Ind.registration_date",
       individual.facility_id                                                                 AS "Ind.facility_id",
       village.title                                                                          AS "Ind.village",
       subcenter.title                                                                        AS "Ind.subcenter",
       phc.title                                                                              AS "Ind.phc",
       block.title                                                                            AS "Ind.block",
       individual.is_voided                                                                   AS "Ind.is_voided",
       op.name                                                                                AS "Enl.Program Name",
       programenrolment.id                                                                    AS "Enl.Id",
       programenrolment.uuid                                                                  AS "Enl.uuid",
       programenrolment.is_voided                                                             AS "Enl.is_voided",
       programenrolment.enrolment_date_time                                                   AS "Enl.enrolment_date_time",
       programenrolment.program_exit_date_time                                                AS "Enl.program_exit_date_time",
       get_coded_string_value(individual.observations -> 'a20a030b-9bef-4ef8-ba8a-88e2b23c1478'::text,
                              concepts.map)::text                                             AS "Ind.Marital status",
       individual.observations ->>
       'a01c2055-7483-4a19-98c1-80fdf955b50c'::text                                           AS "Ind.Number of family members",
       get_coded_string_value(individual.observations -> 'f4028968-bbac-4a66-8fe7-df081321414f'::text,
                              concepts.map)::text                                             AS "Ind.Who is decision making person in family",
       get_coded_string_value(individual.observations -> '8eb5a6ce-7b8a-45cc-a066-fcceca3708f7'::text,
                              concepts.map)::text                                             AS "Ind.Ration card",
       get_coded_string_value(individual.observations -> 'ba25ac4c-784a-4723-8e15-a965a0d63b50'::text,
                              concepts.map)::text                                             AS "Ind.Caste",
       get_coded_string_value(individual.observations -> '5f20070c-1cfe-4e0b-b0db-70dffee99394'::text,
                              concepts.map)::text                                             AS "Ind.Subcaste",
       get_coded_string_value(individual.observations -> 'b9c9d807-7064-46fd-8dc7-1640345dc8cb'::text,
                              concepts.map)::text                                             AS "Ind.Religion",
       get_coded_string_value(individual.observations -> '4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d'::text,
                              concepts.map)::text                                             AS "Ind.Satipati family",
       get_coded_string_value(individual.observations -> '0a668e5b-f3c2-4fc6-8589-d2abda26658b'::text,
                              concepts.map)::text                                             AS "Ind.Addiction",
       get_coded_string_value(individual.observations -> 'e0a3086c-8d69-479e-bf44-258bc27b8105'::text,
                              concepts.map)::text                                             AS "Ind.Addiction - Please specify",
       get_coded_string_value(individual.observations -> '89fe78b2-20a9-45f1-90e3-119a7bc95ce3'::text,
                              concepts.map)::text                                             AS "Ind.Very poor family",
       get_coded_string_value(individual.observations -> '6f03e969-f0bf-4438-a528-5d2ce3b70e15'::text,
                              concepts.map)::text                                             AS "Ind.Occupation of mother",
       get_coded_string_value(individual.observations -> '65a5101b-38fc-4962-876e-e0f8b9ba4cec'::text,
                              concepts.map)::text                                             AS "Ind.Occupation of husband/father",
       get_coded_string_value(individual.observations -> 'e42f5b28-bee4-4a01-aff0-922d823d0075'::text,
                              concepts.map)::text                                             AS "Ind.Mother's education",
       individual.observations ->> '881d9628-eb4f-4056-ae10-09e4ef71cae4'::text               AS "Ind.Mobile number",
       get_coded_string_value(individual.observations -> '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067'::text,
                              concepts.map)::text                                             AS "Ind.Specialy abled",
       get_coded_string_value(individual.observations -> 'a154508a-9d8b-49d9-9d78-b61cbc9daf7f'::text,
                              concepts.map)::text                                             AS "Ind.Specially abled - Please specify",
       get_coded_string_value(individual.observations -> 'd009887c-6d29-4c47-9e34-21e3b9298f44'::text,
                              concepts.map)::text                                             AS "Ind.Any long-term illnesses",
       get_coded_string_value(individual.observations -> '7fa81959-a016-4569-920d-47dee242b27a'::text,
                              concepts.map)::text                                             AS "Ind.Long-term illness - Please specify",
       get_coded_string_value(individual.observations -> '54105452-1752-4661-9d30-2d99bd2d04fa'::text,
                              concepts.map)::text                                             AS "Ind.Toilet facility present",
       get_coded_string_value(individual.observations -> '59db93f0-0963-4e49-87b6-485efb705561'::text,
                              concepts.map)::text                                             AS "Ind.Using the toilet regularly",
       get_coded_string_value(individual.observations -> '789733c4-42ba-4da3-89e6-71da227cf4c2'::text,
                              concepts.map)::text                                             AS "Ind.Source of drinking water",
       (programenrolment.observations ->>
        '0cf252ba-e6b4-4209-903b-4b6d48cd7070'::text)::date                                   AS "Enl.Last menstrual period",
       (programenrolment.observations ->>
        '83e23cc8-52c2-4c8d-8f34-adb98f0db604'::text)::date                                   AS "Enl.Estimated Date of Delivery",
       get_coded_string_value(programenrolment.observations -> '8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c'::text,
                              concepts.map)::text                                             AS "Enl.Previous history of disease",
       programenrolment.observations ->>
       'b5e0662c-7412-4fd1-9a6b-4f0f8c62afc1'::text                                           AS "Enl.Other previous history of disease - Please specify",
       get_coded_string_value(programenrolment.observations -> 'bec0e4d4-8daf-4956-8906-0f579b4cf628'::text,
                              concepts.map)::text                                             AS "Enl.Gravida",
       programenrolment.observations ->>
       '3bf33915-bc67-4431-86eb-a38905be62cf'::text                                           AS "Enl.Number of Abortion",
       programenrolment.observations ->>
       '9acef9b8-8212-49c0-b421-824f9314f319'::text                                           AS "Enl.Number of live childrens",
       programenrolment.observations ->> '76333e77-9ff5-4caf-9a87-021e915f0e9f'::text         AS "Enl.MALE",
       programenrolment.observations ->> '2a523870-c948-4418-8283-902c3494b607'::text         AS "Enl.FEMALE",
       get_coded_string_value(programenrolment.observations -> '4c8e7665-30f1-4f65-b76e-b9132904ed69'::text,
                              concepts.map)::text                                             AS "Enl.Result of last delivery",
       (programenrolment.observations ->>
        '4e89f7b0-0b3d-4902-8f78-6d45ac5614a9'::text)::date                                   AS "Enl.Age of Youngest child",
       get_coded_string_value(programenrolment.observations -> '8e28efd9-7bc8-4870-929d-867ad9367962'::text,
                              concepts.map)::text                                             AS "Enl.Place of last delivery",
       get_coded_string_value(programenrolment.observations -> '9b7af000-0354-4036-a7ab-1f07b43346df'::text,
                              concepts.map)::text                                             AS "Enl.Risk in the last pregnancy",
       get_coded_string_value(programenrolment.observations -> '9f8e78d6-72fc-4f03-9dd9-3ec7f28639df'::text,
                              concepts.map)::text                                             AS "Enl.what kind of risk occurred",
       concepts.map
FROM program_enrolment programenrolment
         CROSS JOIN concepts
         LEFT JOIN operational_program op ON op.program_id = programenrolment.program_id
         LEFT JOIN individual individual ON programenrolment.individual_id = individual.id
         LEFT JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id
WHERE op.uuid::text = '0d9321b2-4bb8-437d-b191-cc39ee00e75a'::text
  AND programenrolment.enrolment_date_time IS NOT NULL;

drop view if exists jnpct_delivery_view;
create view jnpct_delivery_view
            ("Ind.Id", "Ind.address_id", "Ind.uuid", "Ind.first_name", "Ind.last_name", "Ind.Gender",
             "Ind.date_of_birth", "Ind.date_of_birth_verified", "Ind.registration_date", "Ind.facility_id",
             "Ind.village", "Ind.subcenter", "Ind.phc", "Ind.block", "Ind.is_voided", "Enl.Program Name", "Enl.Id",
             "Enl.uuid", "Enl.is_voided", "Enl.enrolment_date_time", "Enl.program_exit_date_time", "Enc.Type", "Enc.Id",
             "Enc.earliest_visit_date_time", "Enc.encounter_date_time", "Enc.program_enrolment_id", "Enc.uuid",
             "Enc.name", "Enc.max_visit_date_time", "Enc.is_voided", "Ind.Marital status",
             "Ind.Number of family members", "Ind.Who is decision making person in family", "Ind.Ration card",
             "Ind.Caste", "Ind.Subcaste", "Ind.Religion", "Ind.Satipati family", "Ind.Addiction",
             "Ind.Addiction - Please specify", "Ind.Very poor family", "Ind.Occupation of mother",
             "Ind.Occupation of husband/father", "Ind.Mother's education", "Ind.Mobile number", "Ind.Specialy abled",
             "Ind.Specially abled - Please specify", "Ind.Any long-term illnesses",
             "Ind.Long-term illness - Please specify", "Ind.Toilet facility present", "Ind.Using the toilet regularly",
             "Ind.Source of drinking water", "Ind.Aadhaar card", "Enl.Last menstrual period",
             "Enl.Estimated Date of Delivery", "Enl.Previous history of disease",
             "Enl.Other previous history of disease - Please specify", "Enl.Gravida", "Enl.Number of Abortion",
             "Enl.Number of live childrens", "Enl.MALE", "Enl.FEMALE", "Enl.Result of last delivery",
             "Enl.Age of Youngest child", "Enl.Place of last delivery", "Enl.Risk in the last pregnancy",
             "Enl.what kind of risk occurred", "Enc.Date of delivery", "Enc.Place of delivery",
             "Enc.Delivery pack used ?", "Enc.Date of discharge", "Enc.Number of days stayed at the hospital",
             "Enc.Week of Gestation", "Enc.Delivered By", "Enc.Type of delivery", "Enc.Delivery outcome",
             "Enc.Delivery complication", "Enc.Number of babies", "Enc.Gender of Newborn1", "Enc.Weight of Newborn1",
             "Enc.Gender of Newborn2", "Enc.Weight of Newborn2", "Enc.Gender of Newborn3", "Enc.Weight of Newborn3",
             "Enc.Number of Stillborn babies", "Enc.Gender of Stillborn1", "Enc.Weight of Stillborn1",
             "Enc.Gender of Stillborn2", "Enc.Weight of Stillborn2", "Enc.Gender of Stillborn3",
             "Enc.Weight of Stillborn3", "Enc.Mother with high risk", "Enc.Did beneficiary inform to Aarogya Saheli?",
             "Enc.Aarogya Saheli present durinng the time of delivery?", "EncCancel.cancel_date_time")
as
WITH concepts AS (
    SELECT hstore(array_agg(c2.uuid)::text[], array_agg(c2.name)::text[]) AS map
    FROM concept
             inner join concept_answer a on concept.id = a.concept_id
             inner join concept c2 on a.answer_concept_id::integer = c2.id
    where concept.uuid in ('f4028968-bbac-4a66-8fe7-df081321414f','8eb5a6ce-7b8a-45cc-a066-fcceca3708f7','ba25ac4c-784a-4723-8e15-a965a0d63b50','5f20070c-1cfe-4e0b-b0db-70dffee99394','b9c9d807-7064-46fd-8dc7-1640345dc8cb','4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d','0a668e5b-f3c2-4fc6-8589-d2abda26658b','e0a3086c-8d69-479e-bf44-258bc27b8105','89fe78b2-20a9-45f1-90e3-119a7bc95ce3','6f03e969-f0bf-4438-a528-5d2ce3b70e15','65a5101b-38fc-4962-876e-e0f8b9ba4cec','e42f5b28-bee4-4a01-aff0-922d823d0075''5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067','a154508a-9d8b-49d9-9d78-b61cbc9daf7f','d009887c-6d29-4c47-9e34-21e3b9298f44','7fa81959-a016-4569-920d-47dee242b27a','54105452-1752-4661-9d30-2d99bd2d04fa','59db93f0-0963-4e49-87b6-485efb705561','789733c4-42ba-4da3-89e6-71da227cf4c2',
                           '8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c','bec0e4d4-8daf-4956-8906-0f579b4cf628','4c8e7665-30f1-4f65-b76e-b9132904ed69','8e28efd9-7bc8-4870-929d-867ad9367962','9b7af000-0354-4036-a7ab-1f07b43346df','9f8e78d6-72fc-4f03-9dd9-3ec7f28639df','95ee3ade-e926-4f8e-a6b9-6c4086a4db3a','ab201e49-cf1c-44c0-8a86-0545a2d57227','c07b4a59-8155-4015-a220-a20c80da9f75','3a896aa4-db6c-42b1-abab-9fb89bd62c79','eb1dd4c0-0465-4865-a357-7325184b29ad','d63cf4d8-e890-4b0f-b331-25aa87f61cc3','d3de7fbb-9851-41b8-9b6a-4c183f4986ea','3f0c5c4e-40bd-476d-a0ae-3a7e19c78c83','8dda0b63-3d60-4a09-888b-e40683c32776','f35f29b3-5c6e-4b8e-a2d9-3847a7f4af3d','ac7d6e60-93c2-4227-b9fa-87ede2c8af96','e28df31b-1434-4dc5-8a65-baa6eb8e30cc','96147a70-1bd0-4210-8260-56c956bf05da','55075e60-068a-46e9-8d12-663a3d9784df','df02e753-a400-436b-870b-97482d131e06')
)
SELECT individual.id                                                                                           AS "Ind.Id",
       individual.address_id                                                                                   AS "Ind.address_id",
       individual.uuid                                                                                         AS "Ind.uuid",
       individual.first_name                                                                                   AS "Ind.first_name",
       individual.last_name                                                                                    AS "Ind.last_name",
       g.name                                                                                                  AS "Ind.Gender",
       individual.date_of_birth                                                                                AS "Ind.date_of_birth",
       individual.date_of_birth_verified                                                                       AS "Ind.date_of_birth_verified",
       individual.registration_date                                                                            AS "Ind.registration_date",
       individual.facility_id                                                                                  AS "Ind.facility_id",
       village.title                                                                                           AS "Ind.village",
       subcenter.title                                                                                         AS "Ind.subcenter",
       phc.title                                                                                               AS "Ind.phc",
       block.title                                                                                             AS "Ind.block",
       individual.is_voided                                                                                    AS "Ind.is_voided",
       op.name                                                                                                 AS "Enl.Program Name",
       programenrolment.id                                                                                     AS "Enl.Id",
       programenrolment.uuid                                                                                   AS "Enl.uuid",
       programenrolment.is_voided                                                                              AS "Enl.is_voided",
       programenrolment.enrolment_date_time                                                                    AS "Enl.enrolment_date_time",
       programenrolment.program_exit_date_time                                                                 AS "Enl.program_exit_date_time",
       oet.name                                                                                                AS "Enc.Type",
       programencounter.id                                                                                     AS "Enc.Id",
       programencounter.earliest_visit_date_time                                                               AS "Enc.earliest_visit_date_time",
       programencounter.encounter_date_time                                                                    AS "Enc.encounter_date_time",
       programencounter.program_enrolment_id                                                                   AS "Enc.program_enrolment_id",
       programencounter.uuid                                                                                   AS "Enc.uuid",
       programencounter.name                                                                                   AS "Enc.name",
       programencounter.max_visit_date_time                                                                    AS "Enc.max_visit_date_time",
       programencounter.is_voided                                                                              AS "Enc.is_voided",
       get_coded_string_value(individual.observations -> 'a20a030b-9bef-4ef8-ba8a-88e2b23c1478'::text,
                              concepts.map)::text                                                              AS "Ind.Marital status",
       individual.observations ->>
       'a01c2055-7483-4a19-98c1-80fdf955b50c'::text                                                            AS "Ind.Number of family members",
       get_coded_string_value(individual.observations -> 'f4028968-bbac-4a66-8fe7-df081321414f'::text,
                              concepts.map)::text                                                              AS "Ind.Who is decision making person in family",
       get_coded_string_value(individual.observations -> '8eb5a6ce-7b8a-45cc-a066-fcceca3708f7'::text,
                              concepts.map)::text                                                              AS "Ind.Ration card",
       get_coded_string_value(individual.observations -> 'ba25ac4c-784a-4723-8e15-a965a0d63b50'::text,
                              concepts.map)::text                                                              AS "Ind.Caste",
       get_coded_string_value(individual.observations -> '5f20070c-1cfe-4e0b-b0db-70dffee99394'::text,
                              concepts.map)::text                                                              AS "Ind.Subcaste",
       get_coded_string_value(individual.observations -> 'b9c9d807-7064-46fd-8dc7-1640345dc8cb'::text,
                              concepts.map)::text                                                              AS "Ind.Religion",
       get_coded_string_value(individual.observations -> '4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d'::text,
                              concepts.map)::text                                                              AS "Ind.Satipati family",
       get_coded_string_value(individual.observations -> '0a668e5b-f3c2-4fc6-8589-d2abda26658b'::text,
                              concepts.map)::text                                                              AS "Ind.Addiction",
       get_coded_string_value(individual.observations -> 'e0a3086c-8d69-479e-bf44-258bc27b8105'::text,
                              concepts.map)::text                                                              AS "Ind.Addiction - Please specify",
       get_coded_string_value(individual.observations -> '89fe78b2-20a9-45f1-90e3-119a7bc95ce3'::text,
                              concepts.map)::text                                                              AS "Ind.Very poor family",
       get_coded_string_value(individual.observations -> '6f03e969-f0bf-4438-a528-5d2ce3b70e15'::text,
                              concepts.map)::text                                                              AS "Ind.Occupation of mother",
       get_coded_string_value(individual.observations -> '65a5101b-38fc-4962-876e-e0f8b9ba4cec'::text,
                              concepts.map)::text                                                              AS "Ind.Occupation of husband/father",
       get_coded_string_value(individual.observations -> 'e42f5b28-bee4-4a01-aff0-922d823d0075'::text,
                              concepts.map)::text                                                              AS "Ind.Mother's education",
       individual.observations ->>
       '881d9628-eb4f-4056-ae10-09e4ef71cae4'::text                                                            AS "Ind.Mobile number",
       get_coded_string_value(individual.observations -> '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067'::text,
                              concepts.map)::text                                                              AS "Ind.Specialy abled",
       get_coded_string_value(individual.observations -> 'a154508a-9d8b-49d9-9d78-b61cbc9daf7f'::text,
                              concepts.map)::text                                                              AS "Ind.Specially abled - Please specify",
       get_coded_string_value(individual.observations -> 'd009887c-6d29-4c47-9e34-21e3b9298f44'::text,
                              concepts.map)::text                                                              AS "Ind.Any long-term illnesses",
       get_coded_string_value(individual.observations -> '7fa81959-a016-4569-920d-47dee242b27a'::text,
                              concepts.map)::text                                                              AS "Ind.Long-term illness - Please specify",
       get_coded_string_value(individual.observations -> '54105452-1752-4661-9d30-2d99bd2d04fa'::text,
                              concepts.map)::text                                                              AS "Ind.Toilet facility present",
       get_coded_string_value(individual.observations -> '59db93f0-0963-4e49-87b6-485efb705561'::text,
                              concepts.map)::text                                                              AS "Ind.Using the toilet regularly",
       get_coded_string_value(individual.observations -> '789733c4-42ba-4da3-89e6-71da227cf4c2'::text,
                              concepts.map)::text                                                              AS "Ind.Source of drinking water",
       individual.observations ->>
       '7170eabd-6f4f-4e30-b22e-85b20a4d854f'::text                                                            AS "Ind.Aadhaar card",
       (programenrolment.observations ->>
        '0cf252ba-e6b4-4209-903b-4b6d48cd7070'::text)::date                                                    AS "Enl.Last menstrual period",
       (programenrolment.observations ->>
        '83e23cc8-52c2-4c8d-8f34-adb98f0db604'::text)::date                                                    AS "Enl.Estimated Date of Delivery",
       get_coded_string_value(programenrolment.observations -> '8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c'::text,
                              concepts.map)::text                                                              AS "Enl.Previous history of disease",
       programenrolment.observations ->>
       'b5e0662c-7412-4fd1-9a6b-4f0f8c62afc1'::text                                                            AS "Enl.Other previous history of disease - Please specify",
       get_coded_string_value(programenrolment.observations -> 'bec0e4d4-8daf-4956-8906-0f579b4cf628'::text,
                              concepts.map)::text                                                              AS "Enl.Gravida",
       programenrolment.observations ->>
       '3bf33915-bc67-4431-86eb-a38905be62cf'::text                                                            AS "Enl.Number of Abortion",
       programenrolment.observations ->>
       '9acef9b8-8212-49c0-b421-824f9314f319'::text                                                            AS "Enl.Number of live childrens",
       programenrolment.observations ->>
       '76333e77-9ff5-4caf-9a87-021e915f0e9f'::text                                                            AS "Enl.MALE",
       programenrolment.observations ->>
       '2a523870-c948-4418-8283-902c3494b607'::text                                                            AS "Enl.FEMALE",
       get_coded_string_value(programenrolment.observations -> '4c8e7665-30f1-4f65-b76e-b9132904ed69'::text,
                              concepts.map)::text                                                              AS "Enl.Result of last delivery",
       (programenrolment.observations ->>
        '4e89f7b0-0b3d-4902-8f78-6d45ac5614a9'::text)::date                                                    AS "Enl.Age of Youngest child",
       get_coded_string_value(programenrolment.observations -> '8e28efd9-7bc8-4870-929d-867ad9367962'::text,
                              concepts.map)::text                                                              AS "Enl.Place of last delivery",
       get_coded_string_value(programenrolment.observations -> '9b7af000-0354-4036-a7ab-1f07b43346df'::text,
                              concepts.map)::text                                                              AS "Enl.Risk in the last pregnancy",
       get_coded_string_value(programenrolment.observations -> '9f8e78d6-72fc-4f03-9dd9-3ec7f28639df'::text,
                              concepts.map)::text                                                               AS "Enl.what kind of risk occurred",
       (programencounter.observations ->>
        'd1effb17-12e7-42b4-8791-8a7c4a7c1a64'::text)::date                                                    AS "Enc.Date of delivery",
       get_coded_string_value(programencounter.observations -> '95ee3ade-e926-4f8e-a6b9-6c4086a4db3a'::text,
                              concepts.map)::text                                                              AS "Enc.Place of delivery",
       get_coded_string_value(programencounter.observations -> 'ab201e49-cf1c-44c0-8a86-0545a2d57227'::text,
                              concepts.map)::text                                                              AS "Enc.Delivery pack used ?",
       (programencounter.observations ->>
        '94f0dddd-0b11-45d7-8aae-7ba9f08b3bb4'::text)::date                                                    AS "Enc.Date of discharge",
       programencounter.observations ->>
       'a2c7a7b3-ef6d-42d1-8d4b-b8b140625c4c'::text                                                            AS "Enc.Number of days stayed at the hospital",
       programencounter.observations ->>
       'f38349e4-afad-4bed-897b-dfb32d8c4c08'::text                                                            AS "Enc.Week of Gestation",
       get_coded_string_value(programencounter.observations -> 'c07b4a59-8155-4015-a220-a20c80da9f75'::text,
                              concepts.map)::text                                                              AS "Enc.Delivered By",
       get_coded_string_value(programencounter.observations -> '3a896aa4-db6c-42b1-abab-9fb89bd62c79'::text,
                              concepts.map)::text                                                              AS "Enc.Type of delivery",
       get_coded_string_value(programencounter.observations -> 'eb1dd4c0-0465-4865-a357-7325184b29ad'::text,
                              concepts.map)::text                                                              AS "Enc.Delivery outcome",
       get_coded_string_value(programencounter.observations -> 'd63cf4d8-e890-4b0f-b331-25aa87f61cc3'::text,
                              concepts.map)::text                                                             AS "Enc.Delivery complication",
       programencounter.observations ->>
       'facf00bd-b1db-4304-b0e4-e484d7e3db29'::text                                                            AS "Enc.Number of babies",
       get_coded_string_value(programencounter.observations -> 'd3de7fbb-9851-41b8-9b6a-4c183f4986ea'::text,
                              concepts.map)::text                                                              AS "Enc.Gender of Newborn1",
       programencounter.observations ->>
       'f0a5edd9-5250-4f27-bc0d-0536b13c8a25'::text                                                            AS "Enc.Weight of Newborn1",
       get_coded_string_value(programencounter.observations -> '3f0c5c4e-40bd-476d-a0ae-3a7e19c78c83'::text,
                              concepts.map)::text                                                              AS "Enc.Gender of Newborn2",
       programencounter.observations ->>
       'b24b1d7d-5c08-495e-a8fc-e0c2c854d694'::text                                                            AS "Enc.Weight of Newborn2",
       get_coded_string_value(programencounter.observations -> '8dda0b63-3d60-4a09-888b-e40683c32776'::text,
                              concepts.map)::text                                                              AS "Enc.Gender of Newborn3",
       programencounter.observations ->>
       'fe7784c0-61ef-481a-98be-7ebeff7cfdde'::text                                                            AS "Enc.Weight of Newborn3",
       programencounter.observations ->>
       'a738b2ba-84a9-4e4f-9e0c-0f2bbafc44b0'::text                                                            AS "Enc.Number of Stillborn babies",
       get_coded_string_value(programencounter.observations -> 'f35f29b3-5c6e-4b8e-a2d9-3847a7f4af3d'::text,
                              concepts.map)::text                                                              AS "Enc.Gender of Stillborn1",
       programencounter.observations ->>
       '69114ef1-3fd1-4a57-b58d-c6e7169fd65c'::text                                                            AS "Enc.Weight of Stillborn1",
       get_coded_string_value(programencounter.observations -> 'ac7d6e60-93c2-4227-b9fa-87ede2c8af96'::text,
                              concepts.map)::text                                                              AS "Enc.Gender of Stillborn2",
       programencounter.observations ->>
       'bed2de93-e2ea-4677-8301-2e6b1173b248'::text                                                            AS "Enc.Weight of Stillborn2",
       get_coded_string_value(programencounter.observations -> 'e28df31b-1434-4dc5-8a65-baa6eb8e30cc'::text,
                              concepts.map)::text                                                              AS "Enc.Gender of Stillborn3",
       programencounter.observations ->>
       '46601220-c8f7-4e1a-bab2-8176ca92f130'::text                                                            AS "Enc.Weight of Stillborn3",
       get_coded_string_value(programencounter.observations -> '96147a70-1bd0-4210-8260-56c956bf05da'::text,
                              concepts.map)::text                                                              AS "Enc.Mother with high risk",
       get_coded_string_value(programencounter.observations -> '55075e60-068a-46e9-8d12-663a3d9784df'::text,
                              concepts.map)::text                                                              AS "Enc.Did beneficiary inform to Aarogya Saheli?",
       get_coded_string_value(programencounter.observations -> 'df02e753-a400-436b-870b-97482d131e06'::text,
                              concepts.map)::text                                                              AS "Enc.Aarogya Saheli present durinng the time of delivery?",
       programencounter.cancel_date_time                                                                       AS "EncCancel.cancel_date_time"
FROM program_encounter programencounter
         CROSS JOIN concepts
         LEFT JOIN operational_encounter_type oet ON programencounter.encounter_type_id = oet.encounter_type_id
         LEFT JOIN program_enrolment programenrolment ON programencounter.program_enrolment_id = programenrolment.id
         LEFT JOIN operational_program op ON op.program_id = programenrolment.program_id
         LEFT JOIN individual individual ON programenrolment.individual_id = individual.id
         LEFT JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id
WHERE op.uuid::text = '0d9321b2-4bb8-437d-b191-cc39ee00e75a'::text
  AND oet.uuid::text = '333b12a7-d21e-4f19-89ac-a82484bae8e7'::text
  AND programencounter.encounter_date_time IS NOT NULL
  AND programenrolment.enrolment_date_time IS NOT NULL;



drop view if exists jnpct_anc_cluster_incharge_visit_view;
create view jnpct_anc_cluster_incharge_visit_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
SELECT  individual.id "Ind.Id",
            individual.address_id "Ind.address_id",
            individual.uuid "Ind.uuid",
            individual.first_name "Ind.first_name",
            individual.last_name "Ind.last_name",
            g.name "Ind.Gender",
            individual.date_of_birth "Ind.date_of_birth",
            individual.date_of_birth_verified "Ind.date_of_birth_verified",
            individual.registration_date "Ind.registration_date",
            individual.facility_id  "Ind.facility_id",
            village.title           "Ind.village",
            subcenter.title         "Ind.subcenter",
            phc.title               "Ind.phc",
            block.title             "Ind.block",
            individual.is_voided "Ind.is_voided",
            op.name "Enl.Program Name",
            programEnrolment.id  "Enl.Id",
            programEnrolment.uuid  "Enl.uuid",
            programEnrolment.is_voided "Enl.is_voided",
            programEnrolment.enrolment_date_time "Enl.enrolment_date_time",
            programEnrolment.program_exit_date_time  "Enl.program_exit_date_time",
            oet.name "Enc.Type",
            programEncounter.id "Enc.Id",
            programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
            programEncounter.encounter_date_time "Enc.encounter_date_time",
            programEncounter.program_enrolment_id "Enc.program_enrolment_id",
            programEncounter.uuid "Enc.uuid",
            programEncounter.name "Enc.name",
            programEncounter.max_visit_date_time "Enc.max_visit_date_time",
            programEncounter.is_voided "Enc.is_voided",
            get_coded_string_value(individual.observations->'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT as "Ind.Marital status",
            (individual.observations->>'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT as "Ind.Number of family members",
            get_coded_string_value(individual.observations->'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT as "Ind.Who is decision making person in family",
            get_coded_string_value(individual.observations->'8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT as "Ind.Ration card",
            get_coded_string_value(individual.observations->'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT as "Ind.Caste",
            get_coded_string_value(individual.observations->'5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT as "Ind.Subcaste",
            get_coded_string_value(individual.observations->'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT as "Ind.Religion",
            get_coded_string_value(individual.observations->'4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT as "Ind.Satipati family",
            get_coded_string_value(individual.observations->'0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT as "Ind.Addiction",
            get_coded_string_value(individual.observations->'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT as "Ind.Addiction - Please specify",
            get_coded_string_value(individual.observations->'89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT as "Ind.Very poor family",
            get_coded_string_value(individual.observations->'6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT as "Ind.Occupation of mother",
            get_coded_string_value(individual.observations->'65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT as "Ind.Occupation of husband/father",
            get_coded_string_value(individual.observations->'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT as "Ind.Mother's education",
            (individual.observations->>'881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT as "Ind.Mobile number",
            get_coded_string_value(individual.observations->'5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT as "Ind.Specialy abled",
            get_coded_string_value(individual.observations->'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT as "Ind.Specially abled - Please specify",
            get_coded_string_value(individual.observations->'d009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT as "Ind.Any long-term illnesses",
            get_coded_string_value(individual.observations->'7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT as "Ind.Long-term illness - Please specify",
            get_coded_string_value(individual.observations->'54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT as "Ind.Toilet facility present",
            get_coded_string_value(individual.observations->'59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT as "Ind.Using the toilet regularly",
            get_coded_string_value(individual.observations->'789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT as "Ind.Source of drinking water",
              (programEnrolment.observations->>'0cf252ba-e6b4-4209-903b-4b6d48cd7070')::DATE as "Enl.Last menstrual period",
              (programEnrolment.observations->>'83e23cc8-52c2-4c8d-8f34-adb98f0db604')::DATE as "Enl.Estimated Date of Delivery",
            get_coded_string_value(programEnrolment.observations->'8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c', concepts.map)::TEXT as "Enl.Previous history of disease",
              (programEnrolment.observations->>'b5e0662c-7412-4fd1-9a6b-4f0f8c62afc1')::TEXT as "Enl.Other previous history of disease - Please specify",
            get_coded_string_value(programEnrolment.observations->'bec0e4d4-8daf-4956-8906-0f579b4cf628', concepts.map)::TEXT as "Enl.Gravida",
              (programEnrolment.observations->>'3bf33915-bc67-4431-86eb-a38905be62cf')::TEXT as "Enl.Number of Abortion",
              (programEnrolment.observations->>'9acef9b8-8212-49c0-b421-824f9314f319')::TEXT as "Enl.Number of live childrens",
              (programEnrolment.observations->>'76333e77-9ff5-4caf-9a87-021e915f0e9f')::TEXT as "Enl.MALE",
              (programEnrolment.observations->>'2a523870-c948-4418-8283-902c3494b607')::TEXT as "Enl.FEMALE",
            get_coded_string_value(programEnrolment.observations->'4c8e7665-30f1-4f65-b76e-b9132904ed69', concepts.map)::TEXT as "Enl.Result of last delivery",
              (programEnrolment.observations->>'4e89f7b0-0b3d-4902-8f78-6d45ac5614a9')::DATE as "Enl.Age of Youngest child",
            get_coded_string_value(programEnrolment.observations->'8e28efd9-7bc8-4870-929d-867ad9367962', concepts.map)::TEXT as "Enl.Place of last delivery",
            get_coded_string_value(programEnrolment.observations->'9b7af000-0354-4036-a7ab-1f07b43346df', concepts.map)::TEXT as "Enl.Risk in the last pregnancy",
            get_coded_string_value(programEnrolment.observations->'9f8e78d6-72fc-4f03-9dd9-3ec7f28639df', concepts.map)::TEXT as "Enl.what kind of risk occurred",
                get_coded_string_value(programEncounter.observations->'4bb3dbde-01df-4f6d-85aa-41a38c8ee3d3', concepts.map)::TEXT as "Enc.Mamta card",
                get_coded_string_value(programEncounter.observations->'3ae2d1a2-734a-4dbf-a1bc-adc19e4e7fff', concepts.map)::TEXT as "Enc.Do you have Iron/Folic acid tablets",
                get_coded_string_value(programEncounter.observations->'734d46fe-363a-4037-afb4-89ff87fbac5b', concepts.map)::TEXT as "Enc.Is she taking iron/folic acid tablet?",
                (programEncounter.observations->>'eccf536c-efbd-4705-9d13-5eaceab49e51')::TEXT as "Enc.IF YES THEN WRITE NUMBER OF TABLET SWALLOWED",
                get_coded_string_value(programEncounter.observations->'bc5c6259-d504-4041-bacd-bbb718d8a845', concepts.map)::TEXT as "Enc.Do you have Calcium tablets?",
                get_coded_string_value(programEncounter.observations->'2c2c44c6-b2c9-4c99-a0da-fcee2cddd14c', concepts.map)::TEXT as "Enc.Is she taking calcium tablet?",
                (programEncounter.observations->>'7fd17431-fada-43e3-891b-d9b311cce9f0')::TEXT as "Enc.IF YES THEN WRITE NUMBER OF CALCIUM TABLET SWALLOWED",
                (programEncounter.observations->>'515b0e64-4621-4f0e-8636-4b68a922decf')::DATE as "Enc.TD 1",
                (programEncounter.observations->>'4ad7f1d8-fa36-47b7-a3b6-83b8909c49ac')::DATE as "Enc.TD 2",
                (programEncounter.observations->>'afdec7b2-ecb2-409a-a506-d6ae3c5f9676')::DATE as "Enc.TD Booster",
                get_coded_string_value(programEncounter.observations->'8b69adbf-2209-4b80-922d-676e4566d43a', concepts.map)::TEXT as "Enc.Does she using iodised salt?",
                get_coded_string_value(programEncounter.observations->'8058e4f8-c64a-446f-a5a7-3b7b0f111fa5', concepts.map)::TEXT as "Enc.Does she get snacks from Anganwadi",
                get_coded_string_value(programEncounter.observations->'09019dea-c24f-46da-bd2f-a2b2e7e5fd88', concepts.map)::TEXT as "Enc.Does she eat all the snacks",
                (programEncounter.observations->>'7d9af174-9e58-4e96-a77c-8351a5a4152d')::TEXT as "Enc.Height"
                ,(programEncounter.observations->>'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT as "Enc.Weight",
                (programEncounter.observations->>'27803190-b702-4223-b9b4-64c75fdcf588')::TEXT as "Enc.BMI",
                (programEncounter.observations->>'915a4d71-6267-4190-af9f-882bbd07629e')::TEXT as "Enc.MUAC (in cms)",
                (programEncounter.observations->>'d5d860cc-9165-45b5-8795-065c2ee0e5aa')::TEXT as "Enc.B.P - Systolic",
                (programEncounter.observations->>'378241fc-b879-4037-bdc3-4746a7a11682')::TEXT as "Enc.B.P - Diastolic",
                get_coded_string_value(programEncounter.observations->'1ba17bfc-1a27-4660-9ec5-e3e314d5eb2c', concepts.map)::TEXT as "Enc.Blood Group",
                (programEncounter.observations->>'51f90d12-e4fb-4cb9-89d4-0c0b45629dbe')::TEXT as "Enc.Temperature",
                get_coded_string_value(programEncounter.observations->'a82b2939-1298-4283-b08b-cbdc8616a54a', concepts.map)::TEXT as "Enc.pedal oedema is present",
                (programEncounter.observations->>'7b2672ae-c6ad-4e12-a408-9feac01183bf')::TEXT as "Enc.IF yes then since how many days",
                get_coded_string_value(programEncounter.observations->'b537a20f-7459-4e7d-9436-d6c702b2403e', concepts.map)::TEXT as "Enc.Pallor",
                get_coded_string_value(programEncounter.observations->'4e7ac362-0578-4b7b-9c3c-1bba0f14e691', concepts.map)::TEXT as "Enc.Has she been having convulsions?",
                get_coded_string_value(programEncounter.observations->'efd91533-e2d0-497e-a4dc-0b66a30ef233', concepts.map)::TEXT as "Enc.Jaundice (Icterus)",
                get_coded_string_value(programEncounter.observations->'e6228ce1-29af-4c48-b41a-858802a5cbc6', concepts.map)::TEXT as "Enc.Breast Examination - Nipple",
                get_coded_string_value(programEncounter.observations->'c23f62f9-9f8f-48bf-8549-a15f0165adf1', concepts.map)::TEXT as "Enc.Is there any danger sign",
                (programEncounter.observations->>'1dc2c60f-e1a8-4f9f-9b05-c8bc96110a91')::TEXT as "Enc.Other complications?",
                get_coded_string_value(programEncounter.observations->'d7ff8486-11bf-4e7a-ba53-acc443923a2c', concepts.map)::TEXT as "Enc.Foetal movements",
                (programEncounter.observations->>'4b30fd1a-ed33-499b-81ea-9dbdfe917b08')::DATE as "Enc.Blood Examination Date",
                (programEncounter.observations->>'057ab538-63ef-4c56-b37c-03651ad823e2')::TEXT as "Enc.H.B",
                (programEncounter.observations->>'23cbc12a-64f7-438f-accb-a1736ea3cc03')::TEXT as "Enc.Blood Sugar",
                get_coded_string_value(programEncounter.observations->'5a48f80d-e956-403d-b192-93a80389faf2', concepts.map)::TEXT as "Enc.VDRL",
                get_coded_string_value(programEncounter.observations->'9c3f92c9-f3a6-49bc-a15e-e7909c8b61cc', concepts.map)::TEXT as "Enc.HIV/AIDS Test",
                get_coded_string_value(programEncounter.observations->'737145a8-3259-4afc-9523-ed5d5f2d9a5f', concepts.map)::TEXT as "Enc.HbsAg",
                get_coded_string_value(programEncounter.observations->'a226cc07-ea19-4bd1-9040-b3c3fdcb5363', concepts.map)::TEXT as "Enc.Sickle cell test  done",
                get_coded_string_value(programEncounter.observations->'c8722864-8f31-4e58-8a3b-ce2c8a549f2b', concepts.map)::TEXT as "Enc.IF YES, result of sickle cell test",
                get_coded_string_value(programEncounter.observations->'ddefc442-cb1f-432a-8e3d-0665dc620272', concepts.map)::TEXT as "Enc.Urine Albumin",
                get_coded_string_value(programEncounter.observations->'b6291b90-6f6e-4b15-be79-51e3284c4c81', concepts.map)::TEXT as "Enc.Urine Sugar",
                get_coded_string_value(programEncounter.observations->'b9bd871d-cb06-4895-907b-adda2572b8c9', concepts.map)::TEXT as "Enc.Complete hospital checkup done",
                (programEncounter.observations->>'0f2f8288-126f-4976-a7bb-09999f7d870e')::DATE as "Enc.If YES then write E.D.D as per USG",
                get_coded_string_value(programEncounter.observations->'ba8274a2-5817-4f1b-a379-f945a285bb25', concepts.map)::TEXT as "Enc.USG Scanning Report - Number of foetus",
                get_coded_string_value(programEncounter.observations->'0197f0ee-97a8-4f68-8049-083f7e81b1dd', concepts.map)::TEXT as "Enc.USG Scanning Report - Amniotic fluid",
                get_coded_string_value(programEncounter.observations->'5aeb53d9-96a4-4e17-8b06-dd58df20771a', concepts.map)::TEXT as "Enc.USG Scanning Report - Placenta Previa",
                get_coded_string_value(programEncounter.observations->'b0e836a1-8878-4798-881a-57a113824f0a', concepts.map)::TEXT as "Enc.Foetal presentation",
                get_coded_string_value(programEncounter.observations->'89265b99-db8c-483f-9ee9-c3b1bab45d91', concepts.map)::TEXT as "Enc.Plan to do delivery?",
                get_coded_string_value(programEncounter.observations->'95ee3ade-e926-4f8e-a6b9-6c4086a4db3a', concepts.map)::TEXT as "Enc.Place of delivery",
                get_coded_string_value(programEncounter.observations->'348bda11-61e5-4feb-bdc9-f6d40cc51614', concepts.map)::TEXT as "Enc.Who will be accompaning you at the time of delivery?",
                get_coded_string_value(programEncounter.observations->'7b0fffa6-e9ee-408f-9d41-e86ba9a9371c', concepts.map)::TEXT as "Enc.COUNSELLING FOR 108",
                get_coded_string_value(programEncounter.observations->'5faf735d-40b1-4542-8dae-24a3f02603f1', concepts.map)::TEXT as "Enc.PLAN IN WHICH HOSPITAL",
                get_coded_string_value(programEncounter.observations->'247d2f74-8404-4d7e-8873-60ed1c9e71c9', concepts.map)::TEXT as "Enc.MONEY SAVED",
                get_coded_string_value(programEncounter.observations->'477bdbfa-5f15-460c-93d9-fa60ad3ce387', concepts.map)::TEXT as "Enc.Who will give blood if required",
                get_coded_string_value(programEncounter.observations->'c3f20991-a82e-4ce5-9f13-473256e52114', concepts.map)::TEXT as "Enc.MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY",
                get_coded_string_value(programEncounter.observations->'c9d2db85-7709-4109-83cf-f6951ab4dbc3', concepts.map)::TEXT as "Enc.Counselling Done for the risk factors / Morbidities to all ",
                get_coded_string_value(programEncounter.observations->'f630f5ae-15bd-489d-9258-a989a70166a2', concepts.map)::TEXT as "Enc.Counselling done for the Government Scheme?",
                get_coded_string_value(programEncounter.observations->'b8576eff-bb29-49c6-ad34-d9970d7e5b36', concepts.map)::TEXT as "Enc.Chiranjivi yojna form is ready?",
                get_coded_string_value(programEncounter.observations->'5587d35b-de18-436c-832d-2dc1295407df', concepts.map)::TEXT as "Enc.Have you enrolled in any government scheme?",
                (programEncounter.observations->>'f76ba360-0079-4c7b-bd16-b79ea26355ad')::TEXT as "Enc.HB measured by color scale",
                get_coded_string_value(programEncounter.observations->'5d5b9e5d-0d66-4138-b6a4-c3c7ba321960', concepts.map)::TEXT as "Enc.Diet Advice Do's",
                get_coded_string_value(programEncounter.observations->'7cdd0689-e7fc-43c2-b4fb-ef168fb7d9b0', concepts.map)::TEXT as "Enc.Diet Advice Don'ts",
                get_coded_string_value(programEncounter.observations->'e6b81ecb-6261-4ea7-822b-efbd84b16ecd', concepts.map)::TEXT as "Enc.Supplementary nutritional therapy (advice)",
                get_coded_string_value(programEncounter.observations->'0b18da58-4e5d-4af0-ad82-c2cb67175e1a', concepts.map)::TEXT as "Enc.Rest and sleep advice Dos",
                get_coded_string_value(programEncounter.observations->'43f54817-6701-416f-a391-fb1cc4133cd8', concepts.map)::TEXT as "Enc.Immunization Counselling (advice)",
                get_coded_string_value(programEncounter.observations->'5ec93cdf-007e-4027-8935-cc9df95fb3a1', concepts.map)::TEXT as "Enc.Coitus/Sex Counselling (advice)",
                get_coded_string_value(programEncounter.observations->'77436bac-3168-40a9-8114-ffa2ce0b04fa', concepts.map)::TEXT as "Enc.Illness management (advice)",
                get_coded_string_value(programEncounter.observations->'cf4a12aa-476f-478c-a6eb-644012117159', concepts.map)::TEXT as "Enc.Finance management (advice)",
                get_coded_string_value(programEncounter.observations->'9f88aa7e-5983-4b18-98ad-7e62ac628272', concepts.map)::TEXT as "Enc.Government scheme information (advice)",
                get_coded_string_value(programEncounter.observations->'350b9426-48ab-4a72-9e67-af6017518786', concepts.map)::TEXT as "Enc.Ambulance services information (advice)",
                programEncounter.cancel_date_time "EncCancel.cancel_date_time",
                get_coded_string_value(programEncounter.observations->'0066a0f7-c087-40f4-ae44-a3e931967767', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
                (programEncounter.observations->>'fadd881a-beed-47ea-a4d6-700009a61a32')::TEXT as "EncCancel.Other reason for cancelling",
                get_coded_string_value(programEncounter.observations->'dde645f5-0f70-45e9-a670-b7190c86c981', concepts.map)::TEXT as "EncCancel.Place of death",
                (programEncounter.observations->>'3b269f11-ed0a-4636-8273-da0259783214')::DATE as "EncCancel.Date of death",
                get_coded_string_value
                (programEncounter.observations->'7c88aea6-dfed-451e-a086-881e2dcfd85f', concepts.map)::TEXT as "EncCancel.Reason of death"

                FROM program_encounter programEncounter
                CROSS JOIN concepts
                LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
                LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
                LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
                LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
                LEFT OUTER JOIN gender g ON g.id = individual.gender_id  LEFT JOIN address_level village ON individual.address_id = village.id
                LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
                LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
                LEFT JOIN address_level block ON phc.parent_id = block.id

                WHERE op.uuid = '0d9321b2-4bb8-437d-b191-cc39ee00e75a'
                AND oet.uuid = '49cd1a24-90bb-409f-8d4f-1e099424b1ac'
                AND programEncounter.encounter_date_time IS NOT NULL
                AND programEnrolment.enrolment_date_time IS NOT NULL
                );


drop view if exists jnpct_anc_visit_view;
create view jnpct_anc_visit_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
    SELECT  individual.id "Ind.Id",
            individual.address_id "Ind.address_id",
            individual.uuid "Ind.uuid",
            individual.first_name "Ind.first_name",
            individual.last_name "Ind.last_name",
            g.name "Ind.Gender",
            individual.date_of_birth "Ind.date_of_birth",
            individual.date_of_birth_verified "Ind.date_of_birth_verified",
            individual.registration_date "Ind.registration_date",
            individual.facility_id  "Ind.facility_id",
            village.title             "Ind.village",
            subcenter.title           "Ind.subcenter",
            phc.title                 "Ind.phc",
            block.title               "Ind.block",
            individual.is_voided "Ind.is_voided",
            op.name "Enl.Program Name",
            programEnrolment.id  "Enl.Id",
            programEnrolment.uuid  "Enl.uuid",
            programEnrolment.is_voided "Enl.is_voided",
            programEnrolment.enrolment_date_time "Enl.enrolment_date_time",
            programEnrolment.program_exit_date_time  "Enl.program_exit_date_time",
            oet.name "Enc.Type",
            programEncounter.id "Enc.Id",
            programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
            programEncounter.encounter_date_time "Enc.encounter_date_time",
            programEncounter.program_enrolment_id "Enc.program_enrolment_id",
            programEncounter.uuid "Enc.uuid",
            programEncounter.name "Enc.name",
            programEncounter.max_visit_date_time "Enc.max_visit_date_time",
            programEncounter.is_voided "Enc.is_voided",
            get_coded_string_value(individual.observations->'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT as "Ind.Marital status",
            (individual.observations->>'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT as "Ind.Number of family members",
            get_coded_string_value(individual.observations->'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT as "Ind.Who is decision making person in family",
            get_coded_string_value(individual.observations->'8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT as "Ind.Ration card",
            get_coded_string_value(individual.observations->'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT as "Ind.Caste",
            get_coded_string_value(individual.observations->'5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT as "Ind.Subcaste",
            get_coded_string_value(individual.observations->'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT as "Ind.Religion",
            get_coded_string_value(individual.observations->'4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT as "Ind.Satipati family",
            get_coded_string_value(individual.observations->'0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT as "Ind.Addiction",
            get_coded_string_value(individual.observations->'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT as "Ind.Addiction - Please specify",
            get_coded_string_value(individual.observations->'89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT as "Ind.Very poor family",
            get_coded_string_value(individual.observations->'6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT as "Ind.Occupation of mother",
            get_coded_string_value(individual.observations->'65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT as "Ind.Occupation of husband/father",
            get_coded_string_value(individual.observations->'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT as "Ind.Mother's education",
            (individual.observations->>'881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT as "Ind.Mobile number",
            get_coded_string_value(individual.observations->'5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT as "Ind.Specialy abled",
            get_coded_string_value(individual.observations->'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT as "Ind.Specially abled - Please specify",
            get_coded_string_value(individual.observations->'d009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT as "Ind.Any long-term illnesses",
            get_coded_string_value(individual.observations->'7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT as "Ind.Long-term illness - Please specify",
            get_coded_string_value(individual.observations->'54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT as "Ind.Toilet facility present",
            get_coded_string_value(individual.observations->'59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT as "Ind.Using the toilet regularly",
            get_coded_string_value(individual.observations->'789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT as "Ind.Source of drinking water",
             (programEnrolment.observations->>'0cf252ba-e6b4-4209-903b-4b6d48cd7070')::DATE as "Enl.Last menstrual period",
             (programEnrolment.observations->>'83e23cc8-52c2-4c8d-8f34-adb98f0db604')::DATE as "Enl.Estimated Date of Delivery",
            get_coded_string_value(programEnrolment.observations->'8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c', concepts.map)::TEXT as "Enl.Previous history of disease",
             (programEnrolment.observations->>'b5e0662c-7412-4fd1-9a6b-4f0f8c62afc1')::TEXT as "Enl.Other previous history of disease - Please specify",
            get_coded_string_value(programEnrolment.observations->'bec0e4d4-8daf-4956-8906-0f579b4cf628', concepts.map)::TEXT as "Enl.Gravida",
             (programEnrolment.observations->>'3bf33915-bc67-4431-86eb-a38905be62cf')::TEXT as "Enl.Number of Abortion",
             (programEnrolment.observations->>'9acef9b8-8212-49c0-b421-824f9314f319')::TEXT as "Enl.Number of live childrens",
             (programEnrolment.observations->>'76333e77-9ff5-4caf-9a87-021e915f0e9f')::TEXT as "Enl.MALE",
             (programEnrolment.observations->>'2a523870-c948-4418-8283-902c3494b607')::TEXT as "Enl.FEMALE",
            get_coded_string_value(programEnrolment.observations->'4c8e7665-30f1-4f65-b76e-b9132904ed69', concepts.map)::TEXT as "Enl.Result of last delivery",
             (programEnrolment.observations->>'4e89f7b0-0b3d-4902-8f78-6d45ac5614a9')::DATE as "Enl.Age of Youngest child",
            get_coded_string_value(programEnrolment.observations->'8e28efd9-7bc8-4870-929d-867ad9367962', concepts.map)::TEXT as "Enl.Place of last delivery",
            get_coded_string_value(programEnrolment.observations->'9b7af000-0354-4036-a7ab-1f07b43346df', concepts.map)::TEXT as "Enl.Risk in the last pregnancy",
            get_coded_string_value(programEnrolment.observations->'9f8e78d6-72fc-4f03-9dd9-3ec7f28639df', concepts.map)::TEXT as "Enl.what kind of risk occurred",
             get_coded_string_value(programEncounter.observations->'4bb3dbde-01df-4f6d-85aa-41a38c8ee3d3', concepts.map)::TEXT as "Enc.Mamta card",
             get_coded_string_value(programEncounter.observations->'3ae2d1a2-734a-4dbf-a1bc-adc19e4e7fff', concepts.map)::TEXT as "Enc.Do you have Iron/Folic acid tablets",
             get_coded_string_value(programEncounter.observations->'734d46fe-363a-4037-afb4-89ff87fbac5b', concepts.map)::TEXT as "Enc.Is she taking iron/folic acid tablet?",
             (programEncounter.observations->>'eccf536c-efbd-4705-9d13-5eaceab49e51')::TEXT as "Enc.IF YES THEN WRITE NUMBER OF TABLET SWALLOWED",
             get_coded_string_value(programEncounter.observations->'bc5c6259-d504-4041-bacd-bbb718d8a845', concepts.map)::TEXT as "Enc.Do you have Calcium tablets?",
              get_coded_string_value(programEncounter.observations->'2c2c44c6-b2c9-4c99-a0da-fcee2cddd14c', concepts.map)::TEXT as "Enc.Is she taking calcium tablet?",
             (programEncounter.observations->>'7fd17431-fada-43e3-891b-d9b311cce9f0')::TEXT as "Enc.IF YES THEN WRITE NUMBER OF CALCIUM TABLET SWALLOWED",
             (programEncounter.observations->>'515b0e64-4621-4f0e-8636-4b68a922decf')::DATE as "Enc.TD 1",
             (programEncounter.observations->>'4ad7f1d8-fa36-47b7-a3b6-83b8909c49ac')::DATE as "Enc.TD 2",
             (programEncounter.observations->>'afdec7b2-ecb2-409a-a506-d6ae3c5f9676')::DATE as "Enc.TD Booster",
             get_coded_string_value(programEncounter.observations->'8b69adbf-2209-4b80-922d-676e4566d43a', concepts.map)::TEXT as "Enc.Does she using iodised salt?",
             get_coded_string_value(programEncounter.observations->'8058e4f8-c64a-446f-a5a7-3b7b0f111fa5', concepts.map)::TEXT as "Enc.Does she get snacks from Anganwadi",
             get_coded_string_value(programEncounter.observations->'09019dea-c24f-46da-bd2f-a2b2e7e5fd88', concepts.map)::TEXT as "Enc.Does she eat all the snacks",
             (programEncounter.observations->>'7d9af174-9e58-4e96-a77c-8351a5a4152d')::TEXT as "Enc.Height",
             (programEncounter.observations->>'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT as "Enc.Weight",
             (programEncounter.observations->>'27803190-b702-4223-b9b4-64c75fdcf588')::TEXT as "Enc.BMI",
             (programEncounter.observations->>'915a4d71-6267-4190-af9f-882bbd07629e')::TEXT as "Enc.MUAC (in cms)",
             (programEncounter.observations->>'d5d860cc-9165-45b5-8795-065c2ee0e5aa')::TEXT as "Enc.B.P - Systolic",
             (programEncounter.observations->>'378241fc-b879-4037-bdc3-4746a7a11682')::TEXT as "Enc.B.P - Diastolic",
             get_coded_string_value(programEncounter.observations->'1ba17bfc-1a27-4660-9ec5-e3e314d5eb2c', concepts.map)::TEXT as "Enc.Blood Group",
             (programEncounter.observations->>'51f90d12-e4fb-4cb9-89d4-0c0b45629dbe')::TEXT as "Enc.Temperature",
             get_coded_string_value(programEncounter.observations->'a82b2939-1298-4283-b08b-cbdc8616a54a', concepts.map)::TEXT as "Enc.pedal oedema is present",
             (programEncounter.observations->>'7b2672ae-c6ad-4e12-a408-9feac01183bf')::TEXT as "Enc.IF yes then since how many days",
             get_coded_string_value(programEncounter.observations->'b537a20f-7459-4e7d-9436-d6c702b2403e', concepts.map)::TEXT as "Enc.Pallor",
             get_coded_string_value(programEncounter.observations->'4e7ac362-0578-4b7b-9c3c-1bba0f14e691', concepts.map)::TEXT as "Enc.Has she been having convulsions?",
             get_coded_string_value(programEncounter.observations->'efd91533-e2d0-497e-a4dc-0b66a30ef233', concepts.map)::TEXT as "Enc.Jaundice (Icterus)",
             get_coded_string_value(programEncounter.observations->'e6228ce1-29af-4c48-b41a-858802a5cbc6', concepts.map)::TEXT as "Enc.Breast Examination - Nipple",
             get_coded_string_value(programEncounter.observations->'c23f62f9-9f8f-48bf-8549-a15f0165adf1', concepts.map)::TEXT as "Enc.Is there any danger sign",
             (programEncounter.observations->>'1dc2c60f-e1a8-4f9f-9b05-c8bc96110a91')::TEXT as "Enc.Other complications?",
             get_coded_string_value(programEncounter.observations->'d7ff8486-11bf-4e7a-ba53-acc443923a2c', concepts.map)::TEXT as "Enc.Foetal movements",
             get_coded_string_value(programEncounter.observations->'4f928472-26bf-43d1-af80-aebbee104801', concepts.map)::TEXT as "Enc.Is laboratory test done?",
    (programEncounter.observations->>'4b30fd1a-ed33-499b-81ea-9dbdfe917b08')::DATE as "Enc.Blood Examination Date",
    (programEncounter.observations->>'057ab538-63ef-4c56-b37c-03651ad823e2')::TEXT as "Enc.H.B",
    (programEncounter.observations->>'23cbc12a-64f7-438f-accb-a1736ea3cc03')::TEXT as "Enc.Blood Sugar",
    get_coded_string_value(programEncounter.observations->'5a48f80d-e956-403d-b192-93a80389faf2', concepts.map)::TEXT as "Enc.VDRL",
    get_coded_string_value(programEncounter.observations->'9c3f92c9-f3a6-49bc-a15e-e7909c8b61cc', concepts.map)::TEXT as "Enc.HIV/AIDS Test",
    get_coded_string_value(programEncounter.observations->'737145a8-3259-4afc-9523-ed5d5f2d9a5f', concepts.map)::TEXT as "Enc.HbsAg",
    get_coded_string_value(programEncounter.observations->'a226cc07-ea19-4bd1-9040-b3c3fdcb5363', concepts.map)::TEXT as "Enc.Sickle cell test  done",
    get_coded_string_value(programEncounter.observations->'c8722864-8f31-4e58-8a3b-ce2c8a549f2b', concepts.map)::TEXT as "Enc.IF YES, result of sickle cell test",
    get_coded_string_value(programEncounter.observations->'ddefc442-cb1f-432a-8e3d-0665dc620272', concepts.map)::TEXT as "Enc.Urine Albumin",
    get_coded_string_value(programEncounter.observations->'b6291b90-6f6e-4b15-be79-51e3284c4c81', concepts.map)::TEXT as "Enc.Urine Sugar",
    get_coded_string_value(programEncounter.observations->'b9bd871d-cb06-4895-907b-adda2572b8c9', concepts.map)::TEXT as "Enc.Complete hospital checkup done",
    (programEncounter.observations->>'0f2f8288-126f-4976-a7bb-09999f7d870e')::DATE as "Enc.If YES then write E.D.D as per USG",
    get_coded_string_value(programEncounter.observations->'ba8274a2-5817-4f1b-a379-f945a285bb25', concepts.map)::TEXT as "Enc.USG Scanning Report - Number of foetus",
    get_coded_string_value(programEncounter.observations->'0197f0ee-97a8-4f68-8049-083f7e81b1dd', concepts.map)::TEXT as "Enc.USG Scanning Report - Amniotic fluid",
    get_coded_string_value(programEncounter.observations->'5aeb53d9-96a4-4e17-8b06-dd58df20771a', concepts.map)::TEXT as "Enc.USG Scanning Report - Placenta Previa",
    get_coded_string_value(programEncounter.observations->'b0e836a1-8878-4798-881a-57a113824f0a', concepts.map)::TEXT as "Enc.Foetal presentation",
    get_coded_string_value(programEncounter.observations->'89265b99-db8c-483f-9ee9-c3b1bab45d91', concepts.map)::TEXT as "Enc.Plan to do delivery?",
    get_coded_string_value(programEncounter.observations->'95ee3ade-e926-4f8e-a6b9-6c4086a4db3a', concepts.map)::TEXT as "Enc.Place of delivery",
    get_coded_string_value(programEncounter.observations->'348bda11-61e5-4feb-bdc9-f6d40cc51614', concepts.map)::TEXT as "Enc.Who will be accompaning you at the time of delivery?",
    get_coded_string_value(programEncounter.observations->'7b0fffa6-e9ee-408f-9d41-e86ba9a9371c', concepts.map)::TEXT as "Enc.COUNSELLING FOR 108",
    get_coded_string_value(programEncounter.observations->'5faf735d-40b1-4542-8dae-24a3f02603f1', concepts.map)::TEXT as "Enc.PLAN IN WHICH HOSPITAL",
    get_coded_string_value(programEncounter.observations->'247d2f74-8404-4d7e-8873-60ed1c9e71c9', concepts.map)::TEXT as "Enc.MONEY SAVED",
    get_coded_string_value(programEncounter.observations->'477bdbfa-5f15-460c-93d9-fa60ad3ce387', concepts.map)::TEXT as "Enc.Who will give blood if required",
    get_coded_string_value(programEncounter.observations->'c3f20991-a82e-4ce5-9f13-473256e52114', concepts.map)::TEXT as "Enc.MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY",
    get_coded_string_value(programEncounter.observations->'c9d2db85-7709-4109-83cf-f6951ab4dbc3', concepts.map)::TEXT as "Enc.Counselling Done for the risk factors / Morbidities to all ",
    get_coded_string_value(programEncounter.observations->'f630f5ae-15bd-489d-9258-a989a70166a2', concepts.map)::TEXT as "Enc.Counselling done for the Government Scheme?",
    get_coded_string_value(programEncounter.observations->'b8576eff-bb29-49c6-ad34-d9970d7e5b36', concepts.map)::TEXT as "Enc.Chiranjivi yojna form is ready?",
    get_coded_string_value(programEncounter.observations->'5587d35b-de18-436c-832d-2dc1295407df', concepts.map)::TEXT as "Enc.Have you enrolled in any government scheme?",
    (programEncounter.observations->>'f76ba360-0079-4c7b-bd16-b79ea26355ad')::TEXT as "Enc.HB measured by color scale",
    get_coded_string_value(programEncounter.observations->'5d5b9e5d-0d66-4138-b6a4-c3c7ba321960', concepts.map)::TEXT as "Enc.Diet Advice Do's",
    get_coded_string_value(programEncounter.observations->'7cdd0689-e7fc-43c2-b4fb-ef168fb7d9b0', concepts.map)::TEXT as "Enc.Diet Advice Don'ts",
    get_coded_string_value(programEncounter.observations->'e6b81ecb-6261-4ea7-822b-efbd84b16ecd', concepts.map)::TEXT as "Enc.Supplementary nutritional therapy (advice)",
    get_coded_string_value(programEncounter.observations->'0b18da58-4e5d-4af0-ad82-c2cb67175e1a', concepts.map)::TEXT as "Enc.Rest and sleep advice Dos",
    get_coded_string_value(programEncounter.observations->'43f54817-6701-416f-a391-fb1cc4133cd8', concepts.map)::TEXT as "Enc.Immunization Counselling (advice)",
    get_coded_string_value(programEncounter.observations->'5ec93cdf-007e-4027-8935-cc9df95fb3a1', concepts.map)::TEXT as "Enc.Coitus/Sex Counselling (advice)",
    get_coded_string_value(programEncounter.observations->'77436bac-3168-40a9-8114-ffa2ce0b04fa', concepts.map)::TEXT as "Enc.Illness management (advice)",
    get_coded_string_value(programEncounter.observations->'cf4a12aa-476f-478c-a6eb-644012117159', concepts.map)::TEXT as "Enc.Finance management (advice)",
    get_coded_string_value(programEncounter.observations->'9f88aa7e-5983-4b18-98ad-7e62ac628272', concepts.map)::TEXT as "Enc.Government scheme information (advice)",
    get_coded_string_value(programEncounter.observations->'350b9426-48ab-4a72-9e67-af6017518786', concepts.map)::TEXT as "Enc.Ambulance services information (advice)",
    programEncounter.cancel_date_time "EncCancel.cancel_date_time",
    get_coded_string_value(programEncounter.observations->'0066a0f7-c087-40f4-ae44-a3e931967767', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
    (programEncounter.observations->>'fadd881a-beed-47ea-a4d6-700009a61a32')::TEXT as "EncCancel.Other reason for cancelling",
    get_coded_string_value(programEncounter.observations->'dde645f5-0f70-45e9-a670-b7190c86c981', concepts.map)::TEXT as "EncCancel.Place of death",
    (programEncounter.observations->>'3b269f11-ed0a-4636-8273-da0259783214')::DATE as "EncCancel.Date of death",
    get_coded_string_value(programEncounter.observations->'7c88aea6-dfed-451e-a086-881e2dcfd85f', concepts.map)::TEXT as "EncCancel.Reason of death"

    FROM program_encounter programEncounter
    CROSS JOIN concepts
    LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
    LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
    LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
    LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
    LEFT OUTER JOIN gender g ON g.id = individual.gender_id
    LEFT JOIN address_level village ON individual.address_id = village.id
    LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
    LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
    LEFT JOIN address_level block ON phc.parent_id = block.id

    WHERE op.uuid = '0d9321b2-4bb8-437d-b191-cc39ee00e75a'
    AND oet.uuid = '984e4ed5-3a70-4691-829b-f1c3e82d837f'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
    );

drop view if exists jnpct_anc_combined_visit_view;

create view jnpct_anc_combined_visit_view
            ("Ind.Id", "Ind.address_id", "Ind.uuid", "Ind.first_name", "Ind.last_name", "Ind.Gender",
             "Ind.date_of_birth", "Ind.date_of_birth_verified", "Ind.registration_date", "Ind.facility_id",
             "Ind.village", "Ind.subcenter", "Ind.phc", "Ind.block", "Ind.is_voided", "Enl.Program Name", "Enl.Id",
             "Enl.uuid", "Enl.is_voided", "Enl.enrolment_date_time", "Enl.program_exit_date_time", "Enc.Type", "Enc.Id",
             "Enc.earliest_visit_date_time", "Enc.encounter_date_time", "Enc.program_enrolment_id", "Enc.uuid",
             "Enc.name", "Enc.max_visit_date_time", "Enc.is_voided", "Ind.Marital status",
             "Ind.Number of family members", "Ind.Who is decision making person in family", "Ind.Ration card",
             "Ind.Caste", "Ind.Subcaste", "Ind.Religion", "Ind.Satipati family", "Ind.Addiction",
             "Ind.Addiction - Please specify", "Ind.Very poor family", "Ind.Occupation of mother",
             "Ind.Occupation of husband/father", "Ind.Mother's education", "Ind.Mobile number", "Ind.Specialy abled",
             "Ind.Specially abled - Please specify", "Ind.Any long-term illnesses",
             "Ind.Long-term illness - Please specify", "Ind.Toilet facility present", "Ind.Using the toilet regularly",
             "Ind.Source of drinking water", "Enl.Last menstrual period", "Enl.Estimated Date of Delivery",
             "Enl.Previous history of disease", "Enl.Other previous history of disease - Please specify", "Enl.Gravida",
             "Enl.Number of Abortion", "Enl.Number of live childrens", "Enl.MALE", "Enl.FEMALE",
             "Enl.Result of last delivery", "Enl.Age of Youngest child", "Enl.Place of last delivery",
             "Enl.Risk in the last pregnancy", "Enl.what kind of risk occurred", "Enc.Mamta card",
             "Enc.Do you have Iron/Folic acid tablets", "Enc.Is she taking iron/folic acid tablet?",
             "Enc.IF YES THEN WRITE NUMBER OF TABLET SWALLOWED", "Enc.Do you have Calcium tablets?",
             "Enc.Is she taking calcium tablet?", "Enc.IF YES THEN WRITE NUMBER OF CALCIUM TABLET SWALLOWED",
             "Enc.TD 1", "Enc.TD 2", "Enc.TD Booster", "Enc.Does she using iodised salt?",
             "Enc.Does she get snacks from Anganwadi", "Enc.Does she eat all the snacks", "Enc.Height", "Enc.Weight",
             "Enc.BMI", "Enc.MUAC (in cms)", "Enc.B.P - Systolic", "Enc.B.P - Diastolic", "Enc.Blood Group",
             "Enc.Temperature", "Enc.pedal oedema is present", "Enc.IF yes then since how many days", "Enc.Pallor",
             "Enc.Has she been having convulsions?", "Enc.Jaundice (Icterus)", "Enc.Breast Examination - Nipple",
             "Enc.Is there any danger sign", "Enc.Other complications?", "Enc.Foetal movements",
             "Enc.Is laboratory test done?", "Enc.Blood Examination Date", "Enc.H.B", "Enc.Blood Sugar", "Enc.VDRL",
             "Enc.HIV/AIDS Test", "Enc.HbsAg", "Enc.Sickle cell test  done", "Enc.IF YES, result of sickle cell test",
             "Enc.Urine Albumin", "Enc.Urine Sugar", "Enc.Complete hospital checkup done",
             "Enc.If YES then write E.D.D as per USG", "Enc.USG Scanning Report - Number of foetus",
             "Enc.USG Scanning Report - Amniotic fluid", "Enc.USG Scanning Report - Placenta Previa",
             "Enc.Foetal presentation", "Enc.Plan to do delivery?", "Enc.Place of delivery",
             "Enc.Who will be accompaning you at the time of delivery?", "Enc.COUNSELLING FOR 108",
             "Enc.PLAN IN WHICH HOSPITAL", "Enc.MONEY SAVED", "Enc.Who will give blood if required",
             "Enc.MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY",
             "Enc.Counselling Done for the risk factors / Morbidities to all ",
             "Enc.Counselling done for the Government Scheme?", "Enc.Chiranjivi yojna form is ready?",
             "Enc.Have you enrolled in any government scheme?", "Enc.HB measured by color scale",
             "Enc.Diet Advice Do's", "Enc.Diet Advice Don'ts", "Enc.Supplementary nutritional therapy (advice)",
             "Enc.Rest and sleep advice Dos", "Enc.Immunization Counselling (advice)",
             "Enc.Coitus/Sex Counselling (advice)", "Enc.Illness management (advice)",
             "Enc.Finance management (advice)", "Enc.Government scheme information (advice)",
             "Enc.Ambulance services information (advice)", "EncCancel.cancel_date_time",
             "EncCancel.Visit cancel reason", "EncCancel.Other reason for cancelling", "EncCancel.Place of death",
             "EncCancel.Date of death", "EncCancel.Reason of death")
as
WITH concepts AS (
    SELECT hstore(array_agg(c2.uuid)::text[], array_agg(c2.name)::text[]) AS map
    FROM concept
             inner join concept_answer a on concept.id = a.concept_id
             inner join concept c2 on a.answer_concept_id::integer = c2.id
    where concept.uuid in ('a20a030b-9bef-4ef8-ba8a-88e2b23c1478','f4028968-bbac-4a66-8fe7-df081321414f','8eb5a6ce-7b8a-45cc-a066-fcceca3708f7','ba25ac4c-784a-4723-8e15-a965a0d63b50','5f20070c-1cfe-4e0b-b0db-70dffee99394','b9c9d807-7064-46fd-8dc7-1640345dc8cb','4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d','0a668e5b-f3c2-4fc6-8589-d2abda26658b','e0a3086c-8d69-479e-bf44-258bc27b8105','89fe78b2-20a9-45f1-90e3-119a7bc95ce3','6f03e969-f0bf-4438-a528-5d2ce3b70e15','65a5101b-38fc-4962-876e-e0f8b9ba4cec','e42f5b28-bee4-4a01-aff0-922d823d0075','5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067','a154508a-9d8b-49d9-9d78-b61cbc9daf7f','d009887c-6d29-4c47-9e34-21e3b9298f44','7fa81959-a016-4569-920d-47dee242b27a','54105452-1752-4661-9d30-2d99bd2d04fa','59db93f0-0963-4e49-87b6-485efb705561','789733c4-42ba-4da3-89e6-71da227cf4c2',
                           '8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c','bec0e4d4-8daf-4956-8906-0f579b4cf628','4c8e7665-30f1-4f65-b76e-b9132904ed69','8e28efd9-7bc8-4870-929d-867ad9367962','9b7af000-0354-4036-a7ab-1f07b43346df','9f8e78d6-72fc-4f03-9dd9-3ec7f28639df','4bb3dbde-01df-4f6d-85aa-41a38c8ee3d3','3ae2d1a2-734a-4dbf-a1bc-adc19e4e7fff','734d46fe-363a-4037-afb4-89ff87fbac5b','bc5c6259-d504-4041-bacd-bbb718d8a845','2c2c44c6-b2c9-4c99-a0da-fcee2cddd14c','8b69adbf-2209-4b80-922d-676e4566d43a','8058e4f8-c64a-446f-a5a7-3b7b0f111fa5','09019dea-c24f-46da-bd2f-a2b2e7e5fd88''1ba17bfc-1a27-4660-9ec5-e3e314d5eb2c','a82b2939-1298-4283-b08b-cbdc8616a54a','b537a20f-7459-4e7d-9436-d6c702b2403e','4e7ac362-0578-4b7b-9c3c-1bba0f14e691','efd91533-e2d0-497e-a4dc-0b66a30ef233','e6228ce1-29af-4c48-b41a-858802a5cbc6','c23f62f9-9f8f-48bf-8549-a15f0165adf1','d7ff8486-11bf-4e7a-ba53-acc443923a2c','4f928472-26bf-43d1-af80-aebbee104801''5a48f80d-e956-403d-b192-93a80389faf2','9c3f92c9-f3a6-49bc-a15e-e7909c8b61cc','737145a8-3259-4afc-9523-ed5d5f2d9a5f','a226cc07-ea19-4bd1-9040-b3c3fdcb5363','c8722864-8f31-4e58-8a3b-ce2c8a549f2b','ddefc442-cb1f-432a-8e3d-0665dc620272','b6291b90-6f6e-4b15-be79-51e3284c4c81','b9bd871d-cb06-4895-907b-adda2572b8c9','ba8274a2-5817-4f1b-a379-f945a285bb25','0197f0ee-97a8-4f68-8049-083f7e81b1dd','5aeb53d9-96a4-4e17-8b06-dd58df20771a','b0e836a1-8878-4798-881a-57a113824f0a','89265b99-db8c-483f-9ee9-c3b1bab45d91','95ee3ade-e926-4f8e-a6b9-6c4086a4db3a','348bda11-61e5-4feb-bdc9-f6d40cc51614','7b0fffa6-e9ee-408f-9d41-e86ba9a9371c','5faf735d-40b1-4542-8dae-24a3f02603f1','247d2f74-8404-4d7e-8873-60ed1c9e71c9','477bdbfa-5f15-460c-93d9-fa60ad3ce387','c3f20991-a82e-4ce5-9f13-473256e52114','c9d2db85-7709-4109-83cf-f6951ab4dbc3','f630f5ae-15bd-489d-9258-a989a70166a2','b8576eff-bb29-49c6-ad34-d9970d7e5b36','5587d35b-de18-436c-832d-2dc1295407df','5d5b9e5d-0d66-4138-b6a4-c3c7ba321960','7cdd0689-e7fc-43c2-b4fb-ef168fb7d9b0','e6b81ecb-6261-4ea7-822b-efbd84b16ecd','0b18da58-4e5d-4af0-ad82-c2cb67175e1a','43f54817-6701-416f-a391-fb1cc4133cd8','5ec93cdf-007e-4027-8935-cc9df95fb3a1','77436bac-3168-40a9-8114-ffa2ce0b04fa','cf4a12aa-476f-478c-a6eb-644012117159','9f88aa7e-5983-4b18-98ad-7e62ac628272','350b9426-48ab-4a72-9e67-af6017518786','0066a0f7-c087-40f4-ae44-a3e931967767','dde645f5-0f70-45e9-a670-b7190c86c981','7c88aea6-dfed-451e-a086-881e2dcfd85f')
)
SELECT individual.id                                                                          AS "Ind.Id",
       individual.address_id                                                                  AS "Ind.address_id",
       individual.uuid                                                                        AS "Ind.uuid",
       individual.first_name                                                                  AS "Ind.first_name",
       individual.last_name                                                                   AS "Ind.last_name",
       g.name                                                                                 AS "Ind.Gender",
       individual.date_of_birth                                                               AS "Ind.date_of_birth",
       individual.date_of_birth_verified                                                      AS "Ind.date_of_birth_verified",
       individual.registration_date                                                           AS "Ind.registration_date",
       individual.facility_id                                                                 AS "Ind.facility_id",
       village.title                                                                          AS "Ind.village",
       subcenter.title                                                                        AS "Ind.subcenter",
       phc.title                                                                              AS "Ind.phc",
       block.title                                                                            AS "Ind.block",
       individual.is_voided                                                                   AS "Ind.is_voided",
       op.name                                                                                AS "Enl.Program Name",
       programenrolment.id                                                                    AS "Enl.Id",
       programenrolment.uuid                                                                  AS "Enl.uuid",
       programenrolment.is_voided                                                             AS "Enl.is_voided",
       programenrolment.enrolment_date_time                                                   AS "Enl.enrolment_date_time",
       programenrolment.program_exit_date_time                                                AS "Enl.program_exit_date_time",
       oet.name                                                                               AS "Enc.Type",
       programencounter.id                                                                    AS "Enc.Id",
       programencounter.earliest_visit_date_time                                              AS "Enc.earliest_visit_date_time",
       programencounter.encounter_date_time                                                   AS "Enc.encounter_date_time",
       programencounter.program_enrolment_id                                                  AS "Enc.program_enrolment_id",
       programencounter.uuid                                                                  AS "Enc.uuid",
       programencounter.name                                                                  AS "Enc.name",
       programencounter.max_visit_date_time                                                   AS "Enc.max_visit_date_time",
       programencounter.is_voided                                                             AS "Enc.is_voided",
       get_coded_string_value(individual.observations -> 'a20a030b-9bef-4ef8-ba8a-88e2b23c1478'::text,
                              concepts.map)::text                                             AS "Ind.Marital status",
       individual.observations ->>
       'a01c2055-7483-4a19-98c1-80fdf955b50c'::text                                           AS "Ind.Number of family members",
       get_coded_string_value(individual.observations -> 'f4028968-bbac-4a66-8fe7-df081321414f'::text,
                              concepts.map)::text                                             AS "Ind.Who is decision making person in family",
       get_coded_string_value(individual.observations -> '8eb5a6ce-7b8a-45cc-a066-fcceca3708f7'::text,
                              concepts.map)::text                                             AS "Ind.Ration card",
       get_coded_string_value(individual.observations -> 'ba25ac4c-784a-4723-8e15-a965a0d63b50'::text,
                              concepts.map)::text                                             AS "Ind.Caste",
       get_coded_string_value(individual.observations -> '5f20070c-1cfe-4e0b-b0db-70dffee99394'::text,
                              concepts.map)::text                                             AS "Ind.Subcaste",
       get_coded_string_value(individual.observations -> 'b9c9d807-7064-46fd-8dc7-1640345dc8cb'::text,
                              concepts.map)::text                                             AS "Ind.Religion",
       get_coded_string_value(individual.observations -> '4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d'::text,
                              concepts.map)::text                                             AS "Ind.Satipati family",
       get_coded_string_value(individual.observations -> '0a668e5b-f3c2-4fc6-8589-d2abda26658b'::text,
                              concepts.map)::text                                             AS "Ind.Addiction",
       get_coded_string_value(individual.observations -> 'e0a3086c-8d69-479e-bf44-258bc27b8105'::text,
                              concepts.map)::text                                             AS "Ind.Addiction - Please specify",
       get_coded_string_value(individual.observations -> '89fe78b2-20a9-45f1-90e3-119a7bc95ce3'::text,
                              concepts.map)::text                                             AS "Ind.Very poor family",
       get_coded_string_value(individual.observations -> '6f03e969-f0bf-4438-a528-5d2ce3b70e15'::text,
                              concepts.map)::text                                             AS "Ind.Occupation of mother",
       get_coded_string_value(individual.observations -> '65a5101b-38fc-4962-876e-e0f8b9ba4cec'::text,
                              concepts.map)::text                                             AS "Ind.Occupation of husband/father",
       get_coded_string_value(individual.observations -> 'e42f5b28-bee4-4a01-aff0-922d823d0075'::text,
                              concepts.map)::text                                             AS "Ind.Mother's education",
       individual.observations ->> '881d9628-eb4f-4056-ae10-09e4ef71cae4'::text               AS "Ind.Mobile number",
       get_coded_string_value(individual.observations -> '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067'::text,
                              concepts.map)::text                                             AS "Ind.Specialy abled",
       get_coded_string_value(individual.observations -> 'a154508a-9d8b-49d9-9d78-b61cbc9daf7f'::text,
                              concepts.map)::text                                             AS "Ind.Specially abled - Please specify",
       get_coded_string_value(individual.observations -> 'd009887c-6d29-4c47-9e34-21e3b9298f44'::text,
                              concepts.map)::text                                             AS "Ind.Any long-term illnesses",
       get_coded_string_value(individual.observations -> '7fa81959-a016-4569-920d-47dee242b27a'::text,
                              concepts.map)::text                                             AS "Ind.Long-term illness - Please specify",
       get_coded_string_value(individual.observations -> '54105452-1752-4661-9d30-2d99bd2d04fa'::text,
                              concepts.map)::text                                             AS "Ind.Toilet facility present",
       get_coded_string_value(individual.observations -> '59db93f0-0963-4e49-87b6-485efb705561'::text,
                              concepts.map)::text                                             AS "Ind.Using the toilet regularly",
       get_coded_string_value(individual.observations -> '789733c4-42ba-4da3-89e6-71da227cf4c2'::text,
                              concepts.map)::text                                             AS "Ind.Source of drinking water",
       (programenrolment.observations ->>
        '0cf252ba-e6b4-4209-903b-4b6d48cd7070'::text)::date                                   AS "Enl.Last menstrual period",
       (programenrolment.observations ->>
        '83e23cc8-52c2-4c8d-8f34-adb98f0db604'::text)::date                                   AS "Enl.Estimated Date of Delivery",
       get_coded_string_value(programenrolment.observations -> '8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c'::text,
                              concepts.map)::text                                             AS "Enl.Previous history of disease",
       programenrolment.observations ->>
       'b5e0662c-7412-4fd1-9a6b-4f0f8c62afc1'::text                                           AS "Enl.Other previous history of disease - Please specify",
       get_coded_string_value(programenrolment.observations -> 'bec0e4d4-8daf-4956-8906-0f579b4cf628'::text,
                              concepts.map)::text                                             AS "Enl.Gravida",
       programenrolment.observations ->>
       '3bf33915-bc67-4431-86eb-a38905be62cf'::text                                           AS "Enl.Number of Abortion",
       programenrolment.observations ->>
       '9acef9b8-8212-49c0-b421-824f9314f319'::text                                           AS "Enl.Number of live childrens",
       programenrolment.observations ->> '76333e77-9ff5-4caf-9a87-021e915f0e9f'::text         AS "Enl.MALE",
       programenrolment.observations ->> '2a523870-c948-4418-8283-902c3494b607'::text         AS "Enl.FEMALE",
       get_coded_string_value(programenrolment.observations -> '4c8e7665-30f1-4f65-b76e-b9132904ed69'::text,
                              concepts.map)::text                                             AS "Enl.Result of last delivery",
       (programenrolment.observations ->>
        '4e89f7b0-0b3d-4902-8f78-6d45ac5614a9'::text)::date                                   AS "Enl.Age of Youngest child",
       get_coded_string_value(programenrolment.observations -> '8e28efd9-7bc8-4870-929d-867ad9367962'::text,
                              concepts.map)::text                                             AS "Enl.Place of last delivery",
       get_coded_string_value(programenrolment.observations -> '9b7af000-0354-4036-a7ab-1f07b43346df'::text,
                              concepts.map)::text                                             AS "Enl.Risk in the last pregnancy",
       get_coded_string_value(programenrolment.observations -> '9f8e78d6-72fc-4f03-9dd9-3ec7f28639df'::text,
                              concepts.map)::text                                             AS "Enl.what kind of risk occurred",
       get_coded_string_value(programencounter.observations -> '4bb3dbde-01df-4f6d-85aa-41a38c8ee3d3'::text,
                              concepts.map)::text                                             AS "Enc.Mamta card",
       get_coded_string_value(programencounter.observations -> '3ae2d1a2-734a-4dbf-a1bc-adc19e4e7fff'::text,
                              concepts.map)::text                                             AS "Enc.Do you have Iron/Folic acid tablets",
       get_coded_string_value(programencounter.observations -> '734d46fe-363a-4037-afb4-89ff87fbac5b'::text,
                              concepts.map)::text                                             AS "Enc.Is she taking iron/folic acid tablet?",
       programencounter.observations ->>
       'eccf536c-efbd-4705-9d13-5eaceab49e51'::text                                           AS "Enc.IF YES THEN WRITE NUMBER OF TABLET SWALLOWED",
       get_coded_string_value(programencounter.observations -> 'bc5c6259-d504-4041-bacd-bbb718d8a845'::text,
                              concepts.map)::text                                             AS "Enc.Do you have Calcium tablets?",
       get_coded_string_value(programencounter.observations -> '2c2c44c6-b2c9-4c99-a0da-fcee2cddd14c'::text,
                              concepts.map)::text                                             AS "Enc.Is she taking calcium tablet?",
       programencounter.observations ->>
       '7fd17431-fada-43e3-891b-d9b311cce9f0'::text                                           AS "Enc.IF YES THEN WRITE NUMBER OF CALCIUM TABLET SWALLOWED",
       (programencounter.observations ->> '515b0e64-4621-4f0e-8636-4b68a922decf'::text)::date AS "Enc.TD 1",
       (programencounter.observations ->> '4ad7f1d8-fa36-47b7-a3b6-83b8909c49ac'::text)::date AS "Enc.TD 2",
       (programencounter.observations ->> 'afdec7b2-ecb2-409a-a506-d6ae3c5f9676'::text)::date AS "Enc.TD Booster",
       get_coded_string_value(programencounter.observations -> '8b69adbf-2209-4b80-922d-676e4566d43a'::text,
                              concepts.map)::text                                             AS "Enc.Does she using iodised salt?",
       get_coded_string_value(programencounter.observations -> '8058e4f8-c64a-446f-a5a7-3b7b0f111fa5'::text,
                              concepts.map)::text                                             AS "Enc.Does she get snacks from Anganwadi",
       get_coded_string_value(programencounter.observations -> '09019dea-c24f-46da-bd2f-a2b2e7e5fd88'::text,
                              concepts.map)::text                                             AS "Enc.Does she eat all the snacks",
       programencounter.observations ->> '7d9af174-9e58-4e96-a77c-8351a5a4152d'::text         AS "Enc.Height",
       programencounter.observations ->> 'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b'::text         AS "Enc.Weight",
       programencounter.observations ->> '27803190-b702-4223-b9b4-64c75fdcf588'::text         AS "Enc.BMI",
       programencounter.observations ->> '915a4d71-6267-4190-af9f-882bbd07629e'::text         AS "Enc.MUAC (in cms)",
       programencounter.observations ->> 'd5d860cc-9165-45b5-8795-065c2ee0e5aa'::text         AS "Enc.B.P - Systolic",
       programencounter.observations ->> '378241fc-b879-4037-bdc3-4746a7a11682'::text         AS "Enc.B.P - Diastolic",
       get_coded_string_value(programencounter.observations -> '1ba17bfc-1a27-4660-9ec5-e3e314d5eb2c'::text,
                              concepts.map)::text                                             AS "Enc.Blood Group",
       programencounter.observations ->> '51f90d12-e4fb-4cb9-89d4-0c0b45629dbe'::text         AS "Enc.Temperature",
       get_coded_string_value(programencounter.observations -> 'a82b2939-1298-4283-b08b-cbdc8616a54a'::text,
                              concepts.map)::text                                             AS "Enc.pedal oedema is present",
       programencounter.observations ->>
       '7b2672ae-c6ad-4e12-a408-9feac01183bf'::text                                           AS "Enc.IF yes then since how many days",
       get_coded_string_value(programencounter.observations -> 'b537a20f-7459-4e7d-9436-d6c702b2403e'::text,
                              concepts.map)::text                                             AS "Enc.Pallor",
       get_coded_string_value(programencounter.observations -> '4e7ac362-0578-4b7b-9c3c-1bba0f14e691'::text,
                              concepts.map)::text                                             AS "Enc.Has she been having convulsions?",
       get_coded_string_value(programencounter.observations -> 'efd91533-e2d0-497e-a4dc-0b66a30ef233'::text,
                              concepts.map)::text                                             AS "Enc.Jaundice (Icterus)",
       get_coded_string_value(programencounter.observations -> 'e6228ce1-29af-4c48-b41a-858802a5cbc6'::text,
                              concepts.map)::text                                             AS "Enc.Breast Examination - Nipple",
       get_coded_string_value(programencounter.observations -> 'c23f62f9-9f8f-48bf-8549-a15f0165adf1'::text,
                              concepts.map)::text                                             AS "Enc.Is there any danger sign",
       programencounter.observations ->>
       '1dc2c60f-e1a8-4f9f-9b05-c8bc96110a91'::text                                           AS "Enc.Other complications?",
       get_coded_string_value(programencounter.observations -> 'd7ff8486-11bf-4e7a-ba53-acc443923a2c'::text,
                              concepts.map)::text                                             AS "Enc.Foetal movements",
       get_coded_string_value(programencounter.observations -> '4f928472-26bf-43d1-af80-aebbee104801'::text,
                              concepts.map)::text                                             AS "Enc.Is laboratory test done?",
       (programencounter.observations ->>
        '4b30fd1a-ed33-499b-81ea-9dbdfe917b08'::text)::date                                   AS "Enc.Blood Examination Date",
       programencounter.observations ->> '057ab538-63ef-4c56-b37c-03651ad823e2'::text         AS "Enc.H.B",
       programencounter.observations ->> '23cbc12a-64f7-438f-accb-a1736ea3cc03'::text         AS "Enc.Blood Sugar",
       get_coded_string_value(programencounter.observations -> '5a48f80d-e956-403d-b192-93a80389faf2'::text,
                              concepts.map)::text                                             AS "Enc.VDRL",
       get_coded_string_value(programencounter.observations -> '9c3f92c9-f3a6-49bc-a15e-e7909c8b61cc'::text,
                              concepts.map)::text                                             AS "Enc.HIV/AIDS Test",
       get_coded_string_value(programencounter.observations -> '737145a8-3259-4afc-9523-ed5d5f2d9a5f'::text,
                              concepts.map)::text                                             AS "Enc.HbsAg",
       get_coded_string_value(programencounter.observations -> 'a226cc07-ea19-4bd1-9040-b3c3fdcb5363'::text,
                              concepts.map)::text                                             AS "Enc.Sickle cell test  done",
       get_coded_string_value(programencounter.observations -> 'c8722864-8f31-4e58-8a3b-ce2c8a549f2b'::text,
                              concepts.map)::text                                             AS "Enc.IF YES, result of sickle cell test",
       get_coded_string_value(programencounter.observations -> 'ddefc442-cb1f-432a-8e3d-0665dc620272'::text,
                              concepts.map)::text                                             AS "Enc.Urine Albumin",
       get_coded_string_value(programencounter.observations -> 'b6291b90-6f6e-4b15-be79-51e3284c4c81'::text,
                              concepts.map)::text                                             AS "Enc.Urine Sugar",
       get_coded_string_value(programencounter.observations -> 'b9bd871d-cb06-4895-907b-adda2572b8c9'::text,
                              concepts.map)::text                                             AS "Enc.Complete hospital checkup done",
       (programencounter.observations ->>
        '0f2f8288-126f-4976-a7bb-09999f7d870e'::text)::date                                   AS "Enc.If YES then write E.D.D as per USG",
       get_coded_string_value(programencounter.observations -> 'ba8274a2-5817-4f1b-a379-f945a285bb25'::text,
                              concepts.map)::text                                             AS "Enc.USG Scanning Report - Number of foetus",
       get_coded_string_value(programencounter.observations -> '0197f0ee-97a8-4f68-8049-083f7e81b1dd'::text,
                              concepts.map)::text                                             AS "Enc.USG Scanning Report - Amniotic fluid",
       get_coded_string_value(programencounter.observations -> '5aeb53d9-96a4-4e17-8b06-dd58df20771a'::text,
                              concepts.map)::text                                             AS "Enc.USG Scanning Report - Placenta Previa",
       get_coded_string_value(programencounter.observations -> 'b0e836a1-8878-4798-881a-57a113824f0a'::text,
                              concepts.map)::text                                             AS "Enc.Foetal presentation",
       get_coded_string_value(programencounter.observations -> '89265b99-db8c-483f-9ee9-c3b1bab45d91'::text,
                              concepts.map)::text                                             AS "Enc.Plan to do delivery?",
       get_coded_string_value(programencounter.observations -> '95ee3ade-e926-4f8e-a6b9-6c4086a4db3a'::text,
                              concepts.map)::text                                             AS "Enc.Place of delivery",
       get_coded_string_value(programencounter.observations -> '348bda11-61e5-4feb-bdc9-f6d40cc51614'::text,
                              concepts.map)::text                                             AS "Enc.Who will be accompaning you at the time of delivery?",
       get_coded_string_value(programencounter.observations -> '7b0fffa6-e9ee-408f-9d41-e86ba9a9371c'::text,
                              concepts.map)::text                                             AS "Enc.COUNSELLING FOR 108",
       get_coded_string_value(programencounter.observations -> '5faf735d-40b1-4542-8dae-24a3f02603f1'::text,
                              concepts.map)::text                                             AS "Enc.PLAN IN WHICH HOSPITAL",
       get_coded_string_value(programencounter.observations -> '247d2f74-8404-4d7e-8873-60ed1c9e71c9'::text,
                              concepts.map)::text                                             AS "Enc.MONEY SAVED",
       get_coded_string_value(programencounter.observations -> '477bdbfa-5f15-460c-93d9-fa60ad3ce387'::text,
                              concepts.map)::text                                             AS "Enc.Who will give blood if required",
       get_coded_string_value(programencounter.observations -> 'c3f20991-a82e-4ce5-9f13-473256e52114'::text,
                              concepts.map)::text                                             AS "Enc.MAKE CLOTHES READY FOR THE DELIVERY AND NEW BORN BABY",
       get_coded_string_value(programencounter.observations -> 'c9d2db85-7709-4109-83cf-f6951ab4dbc3'::text,
                              concepts.map)::text                                             AS "Enc.Counselling Done for the risk factors / Morbidities to all ",
       get_coded_string_value(programencounter.observations -> 'f630f5ae-15bd-489d-9258-a989a70166a2'::text,
                              concepts.map)::text                                             AS "Enc.Counselling done for the Government Scheme?",
       get_coded_string_value(programencounter.observations -> 'b8576eff-bb29-49c6-ad34-d9970d7e5b36'::text,
                              concepts.map)::text                                             AS "Enc.Chiranjivi yojna form is ready?",
       get_coded_string_value(programencounter.observations -> '5587d35b-de18-436c-832d-2dc1295407df'::text,
                              concepts.map)::text                                             AS "Enc.Have you enrolled in any government scheme?",
       programencounter.observations ->>
       'f76ba360-0079-4c7b-bd16-b79ea26355ad'::text                                           AS "Enc.HB measured by color scale",
       get_coded_string_value(programencounter.observations -> '5d5b9e5d-0d66-4138-b6a4-c3c7ba321960'::text,
                              concepts.map)::text                                             AS "Enc.Diet Advice Do's",
       get_coded_string_value(programencounter.observations -> '7cdd0689-e7fc-43c2-b4fb-ef168fb7d9b0'::text,
                              concepts.map)::text                                             AS "Enc.Diet Advice Don'ts",
       get_coded_string_value(programencounter.observations -> 'e6b81ecb-6261-4ea7-822b-efbd84b16ecd'::text,
                              concepts.map)::text                                             AS "Enc.Supplementary nutritional therapy (advice)",
       get_coded_string_value(programencounter.observations -> '0b18da58-4e5d-4af0-ad82-c2cb67175e1a'::text,
                              concepts.map)::text                                             AS "Enc.Rest and sleep advice Dos",
       get_coded_string_value(programencounter.observations -> '43f54817-6701-416f-a391-fb1cc4133cd8'::text,
                              concepts.map)::text                                             AS "Enc.Immunization Counselling (advice)",
       get_coded_string_value(programencounter.observations -> '5ec93cdf-007e-4027-8935-cc9df95fb3a1'::text,
                              concepts.map)::text                                             AS "Enc.Coitus/Sex Counselling (advice)",
       get_coded_string_value(programencounter.observations -> '77436bac-3168-40a9-8114-ffa2ce0b04fa'::text,
                              concepts.map)::text                                             AS "Enc.Illness management (advice)",
       get_coded_string_value(programencounter.observations -> 'cf4a12aa-476f-478c-a6eb-644012117159'::text,
                              concepts.map)::text                                             AS "Enc.Finance management (advice)",
       get_coded_string_value(programencounter.observations -> '9f88aa7e-5983-4b18-98ad-7e62ac628272'::text,
                              concepts.map)::text                                             AS "Enc.Government scheme information (advice)",
       get_coded_string_value(programencounter.observations -> '350b9426-48ab-4a72-9e67-af6017518786'::text,
                              concepts.map)::text                                             AS "Enc.Ambulance services information (advice)",
       programencounter.cancel_date_time                                                      AS "EncCancel.cancel_date_time",
       get_coded_string_value(programencounter.observations -> '0066a0f7-c087-40f4-ae44-a3e931967767'::text,
                              concepts.map)::text                                             AS "EncCancel.Visit cancel reason",
       programencounter.observations ->>
       'fadd881a-beed-47ea-a4d6-700009a61a32'::text                                           AS "EncCancel.Other reason for cancelling",
       get_coded_string_value(programencounter.observations -> 'dde645f5-0f70-45e9-a670-b7190c86c981'::text,
                              concepts.map)::text                                             AS "EncCancel.Place of death",
       (programencounter.observations ->>
        '3b269f11-ed0a-4636-8273-da0259783214'::text)::date                                   AS "EncCancel.Date of death",
       get_coded_string_value(programencounter.observations -> '7c88aea6-dfed-451e-a086-881e2dcfd85f'::text,
                              concepts.map)::text                                             AS "EncCancel.Reason of death"
FROM program_encounter programencounter
         CROSS JOIN concepts
         LEFT JOIN operational_encounter_type oet ON programencounter.encounter_type_id = oet.encounter_type_id
         LEFT JOIN program_enrolment programenrolment ON programencounter.program_enrolment_id = programenrolment.id
         LEFT JOIN operational_program op ON op.program_id = programenrolment.program_id
         LEFT JOIN individual individual ON programenrolment.individual_id = individual.id
         LEFT JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id
WHERE op.uuid::text = '0d9321b2-4bb8-437d-b191-cc39ee00e75a'::text
  AND (oet.uuid::text = '984e4ed5-3a70-4691-829b-f1c3e82d837f'::text OR
       oet.uuid::text = '49cd1a24-90bb-409f-8d4f-1e099424b1ac'::text)
  AND programencounter.encounter_date_time IS NOT NULL
  AND programenrolment.enrolment_date_time IS NOT NULL;

drop view if exists jnpct_pnc_visit_view;
create view jnpct_pnc_visit_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
     SELECT  individual.id "Ind.Id",
       individual.address_id "Ind.address_id",
       individual.uuid "Ind.uuid",
       individual.first_name "Ind.first_name",
       individual.last_name "Ind.last_name",
       g.name "Ind.Gender",
       individual.date_of_birth "Ind.date_of_birth",
       individual.date_of_birth_verified "Ind.date_of_birth_verified",
       individual.registration_date "Ind.registration_date",
       individual.facility_id  "Ind.facility_id",
       village.title             "Ind.village",
       subcenter.title           "Ind.subcenter",
       phc.title                 "Ind.phc",
       block.title               "Ind.block",
       individual.is_voided "Ind.is_voided",
       op.name "Enl.Program Name",
       programEnrolment.id  "Enl.Id",
       programEnrolment.uuid  "Enl.uuid",
       programEnrolment.is_voided "Enl.is_voided",
       oet.name "Enc.Type",
       programEncounter.id "Enc.Id",
       programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
       programEncounter.encounter_date_time "Enc.encounter_date_time",
       programEncounter.program_enrolment_id "Enc.program_enrolment_id",
       programEnrolment.enrolment_date_time "Enl.enrolment_date_time",
       programEnrolment.program_exit_date_time  "Enl.program_exit_date_time",
       programEncounter.uuid "Enc.uuid",
       programEncounter.name "Enc.name",
       programEncounter.max_visit_date_time "Enc.max_visit_date_time",
       programEncounter.is_voided "Enc.is_voided",
       get_coded_string_value(individual.observations->'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT as "Ind.Marital status",
       (individual.observations->>'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT as "Ind.Number of family members",
       get_coded_string_value(individual.observations->'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT as "Ind.Who is decision making person in family",
       get_coded_string_value(individual.observations->'8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT as "Ind.Ration card",
       get_coded_string_value(individual.observations->'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT as "Ind.Caste",
       get_coded_string_value(individual.observations->'5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT as "Ind.Subcaste",
       get_coded_string_value(individual.observations->'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT as "Ind.Religion",
       get_coded_string_value(individual.observations->'4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT as "Ind.Satipati family",
       get_coded_string_value(individual.observations->'0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT as "Ind.Addiction",
       get_coded_string_value(individual.observations->'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT as "Ind.Addiction - Please specify",
       get_coded_string_value(individual.observations->'89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT as "Ind.Very poor family",
       get_coded_string_value(individual.observations->'6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT as "Ind.Occupation of mother",
       get_coded_string_value(individual.observations->'65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT as "Ind.Occupation of husband/father",
       get_coded_string_value(individual.observations->'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT as "Ind.Mother's education",
       (individual.observations->>'881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT as "Ind.Mobile number",
       get_coded_string_value(individual.observations->'5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT as "Ind.Specialy abled",
       get_coded_string_value(individual.observations->'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT as "Ind.Specially abled - Please specify",
       get_coded_string_value(individual.observations->'d009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT as "Ind.Any long-term illnesses",
       get_coded_string_value(individual.observations->'7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT as "Ind.Long-term illness - Please specify",
       get_coded_string_value(individual.observations->'54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT as "Ind.Toilet facility present",
       get_coded_string_value(individual.observations->'59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT as "Ind.Using the toilet regularly",
       get_coded_string_value(individual.observations->'789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT as "Ind.Source of drinking water",
        (programEnrolment.observations->>'0cf252ba-e6b4-4209-903b-4b6d48cd7070')::DATE as "Enl.Last menstrual period",
        (programEnrolment.observations->>'83e23cc8-52c2-4c8d-8f34-adb98f0db604')::DATE as "Enl.Estimated Date of Delivery",
       get_coded_string_value(programEnrolment.observations->'8bee6542-cd1e-4bd8-b0d4-5a88575fcb1c', concepts.map)::TEXT as "Enl.Previous history of disease",
        (programEnrolment.observations->>'b5e0662c-7412-4fd1-9a6b-4f0f8c62afc1')::TEXT as "Enl.Other previous history of disease - Please specify",
       get_coded_string_value(programEnrolment.observations->'bec0e4d4-8daf-4956-8906-0f579b4cf628', concepts.map)::TEXT as "Enl.Gravida",
        (programEnrolment.observations->>'3bf33915-bc67-4431-86eb-a38905be62cf')::TEXT as "Enl.Number of Abortion",
        (programEnrolment.observations->>'9acef9b8-8212-49c0-b421-824f9314f319')::TEXT as "Enl.Number of live childrens",
        (programEnrolment.observations->>'76333e77-9ff5-4caf-9a87-021e915f0e9f')::TEXT as "Enl.MALE",
        (programEnrolment.observations->>'2a523870-c948-4418-8283-902c3494b607')::TEXT as "Enl.FEMALE",
          get_coded_string_value(programEnrolment.observations->'4c8e7665-30f1-4f65-b76e-b9132904ed69', concepts.map)::TEXT as "Enl.Result of last delivery",
        (programEnrolment.observations->>'4e89f7b0-0b3d-4902-8f78-6d45ac5614a9')::DATE as "Enl.Age of Youngest child",
          get_coded_string_value(programEnrolment.observations->'8e28efd9-7bc8-4870-929d-867ad9367962', concepts.map)::TEXT as "Enl.Place of last delivery",
          get_coded_string_value(programEnrolment.observations->'9b7af000-0354-4036-a7ab-1f07b43346df', concepts.map)::TEXT as "Enl.Risk in the last pregnancy",
          get_coded_string_value(programEnrolment.observations->'9f8e78d6-72fc-4f03-9dd9-3ec7f28639df', concepts.map)::TEXT as "Enl.what kind of risk occurred",
          (programEncounter.observations->>'14db9754-cb53-4948-ab69-ea18956bf8da')::TEXT as "Enc.Which day after Delivery",
          (programEncounter.observations->>'9bdb7db1-b1ac-477c-a278-e130c077fc77')::TEXT as "Enc.BP Systolic",
          (programEncounter.observations->>'a5998291-545a-4de2-861e-e307354f462c')::TEXT as "Enc.BP Diastolic",
          (programEncounter.observations->>'51f90d12-e4fb-4cb9-89d4-0c0b45629dbe')::TEXT as "Enc.Temperature",
          (programEncounter.observations->>'9f6eb23b-9e82-47da-b22b-290a840365df')::TEXT as "Enc.Hb % Level",
          get_coded_string_value(programEncounter.observations->'3d99ab9e-9cf5-4db2-a8e9-e5054242dcd2', concepts.map)::TEXT as "Enc.Post-Partum Haemorrhage symptoms",
          get_coded_string_value(programEncounter.observations->'eb34a8a4-34e3-469f-9458-4ebe488ae1a8', concepts.map)::TEXT as "Enc.Any abdominal problems",
          get_coded_string_value(programEncounter.observations->'97584ff6-7545-4220-9bbe-5b1f1a59566c', concepts.map)::TEXT as "Enc.Any vaginal problems",
          get_coded_string_value(programEncounter.observations->'585e291e-1f3d-41fa-b6f4-3dcd96cf1560', concepts.map)::TEXT as "Enc.Any difficulties with urinating",
          get_coded_string_value(programEncounter.observations->'092b60b6-9df8-4186-ba94-8487163152da', concepts.map)::TEXT as "Enc.Any breast problems",
          get_coded_string_value(programEncounter.observations->'27839269-6314-4959-9433-1e547b7b5986', concepts.map)::TEXT as "Enc.Episiotomy done?",
          get_coded_string_value(programEncounter.observations->'403aabf9-ec66-49ed-8615-f62ca33de2f0', concepts.map)::TEXT as "Enc.How is the incision area?",
          get_coded_string_value(programEncounter.observations->'426b8f0f-b57b-4d2e-964b-b1838d2159c5', concepts.map)::TEXT as "Enc.Does feel hot or have the chills?",
          get_coded_string_value(programEncounter.observations->'1c0e744f-33cb-4792-be6c-6e6ddd178bfe', concepts.map)::TEXT as "Enc.Convulsions",
          get_coded_string_value(programEncounter.observations->'cfec5288-ca3e-48c3-a1f2-332038ad2241', concepts.map)::TEXT as "Enc.Post partum dipression symptoms",
          get_coded_string_value(programEncounter.observations->'056689c5-ba68-4e85-b515-7c342769e47b', concepts.map)::TEXT as "Enc.Burning micturation?",
          get_coded_string_value(programEncounter.observations->'20b2d6cb-1c2e-4456-be7e-b26d46648161', concepts.map)::TEXT as "Enc.Does she has bleeding now?",
          get_coded_string_value(programEncounter.observations->'2d522614-ad6c-4673-b6af-ca5a366540cc', concepts.map)::TEXT as "Enc.How many pads changed?",
          get_coded_string_value(programEncounter.observations->'b28d26ac-2337-4651-bb55-123b71ee39f3', concepts.map)::TEXT as "Enc.Does she taking iron tablet?",
          (programEncounter.observations->>'eccf536c-efbd-4705-9d13-5eaceab49e51')::TEXT as "Enc.IF YES THEN WRITE NUMBER OF TABLET SWALLOWED",
          get_coded_string_value(programEncounter.observations->'a34575f1-1373-48d1-b94a-2e1421bb3348', concepts.map)::TEXT as "Enc.Does she taking calcium tablet?",
          (programEncounter.observations->>'7fd17431-fada-43e3-891b-d9b311cce9f0')::TEXT as "Enc.IF YES THEN WRITE NUMBER OF CALCIUM TABLET SWALLOWED",
          get_coded_string_value(programEncounter.observations->'5d5b9e5d-0d66-4138-b6a4-c3c7ba321960', concepts.map)::TEXT as "Enc.Diet Advice Do's",
          get_coded_string_value(programEncounter.observations->'7cdd0689-e7fc-43c2-b4fb-ef168fb7d9b0', concepts.map)::TEXT as "Enc.Diet Advice Don'ts",
          get_coded_string_value(programEncounter.observations->'e6b81ecb-6261-4ea7-822b-efbd84b16ecd', concepts.map)::TEXT as "Enc.Supplementary nutritional therapy (advice)",
          get_coded_string_value(programEncounter.observations->'0b18da58-4e5d-4af0-ad82-c2cb67175e1a', concepts.map)::TEXT as "Enc.Rest and sleep advice Dos",
          get_coded_string_value(programEncounter.observations->'368bf985-a91a-4c88-a8f7-7bd7b5a70e42', concepts.map)::TEXT as "Enc.Rest and sleep advice Donts",
          get_coded_string_value(programEncounter.observations->'77afb064-ad7d-44b8-be27-2686726cc409', concepts.map)::TEXT as "Enc.Breast Feeding advice",
          get_coded_string_value(programEncounter.observations->'cddc0438-74a1-4bcb-843c-34a47da7c1e4', concepts.map)::TEXT as "Enc.Hygiene advice",
          get_coded_string_value(programEncounter.observations->'f860273e-29f0-4b44-9da2-a54e15ea12fe', concepts.map)::TEXT as "Enc.Immunization advice",
          get_coded_string_value(programEncounter.observations->'79f8e116-6ce4-47d0-9580-99e718d2234f', concepts.map)::TEXT as "Enc.Family Planning advice Dos",
          get_coded_string_value(programEncounter.observations->'6438bcf0-ca7a-4235-a8e1-f17fe08720c5', concepts.map)::TEXT as "Enc.Family Planning advice Donts",
          programEncounter.cancel_date_time "EncCancel.cancel_date_time",
          get_coded_string_value(programEncounter.observations->'0066a0f7-c087-40f4-ae44-a3e931967767', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
          (programEncounter.observations->>'fadd881a-beed-47ea-a4d6-700009a61a32')::TEXT as "EncCancel.Other reason for cancelling",
          get_coded_string_value(programEncounter.observations->'dde645f5-0f70-45e9-a670-b7190c86c981', concepts.map)::TEXT as "EncCancel.Place of death",
          (programEncounter.observations->>'3b269f11-ed0a-4636-8273-da0259783214')::DATE as "EncCancel.Date of death",
     get_coded_string_value(programEncounter.observations->'7c88aea6-dfed-451e-a086-881e2dcfd85f', concepts.map)::TEXT as "EncCancel.Reason of death"

     FROM program_encounter programEncounter
     CROSS JOIN concepts
     LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
     LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
     LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
     LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
     LEFT OUTER JOIN gender g ON g.id = individual.gender_id LEFT JOIN address_level village ON individual.address_id = village.id
    LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
    LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
    LEFT JOIN address_level block ON phc.parent_id = block.id


     WHERE op.uuid = '0d9321b2-4bb8-437d-b191-cc39ee00e75a'
      AND oet.uuid = '6c5d47ee-b582-45aa-9610-fb6b6593f570'
      AND programEncounter.encounter_date_time IS NOT NULL
      AND programEnrolment.enrolment_date_time IS NOT NULL

    );

drop view if exists jnpct_child_birth_form_view;
create view jnpct_child_birth_form_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
  SELECT individual.id                                                                          "Ind.Id",
         individual.address_id                                                                  "Ind.address_id",
         individual.uuid                                                                        "Ind.uuid",
         individual.first_name                                                                  "Ind.first_name",
         individual.last_name                                                                   "Ind.last_name",
         g.name                                                                                 "Ind.Gender",
         individual.date_of_birth                                                               "Ind.date_of_birth",
         individual.date_of_birth_verified                                                      "Ind.date_of_birth_verified",
         individual.registration_date                                                           "Ind.registration_date",
         individual.facility_id                                                                 "Ind.facility_id",
         village.title                                                                          "Ind.village",
         subcenter.title                                                                        "Ind.subcenter",
         phc.title                                                                              "Ind.phc",
         block.title                                                                            "Ind.block",
         individual.is_voided                                                                   "Ind.is_voided",
         op.name                                                                                "Enl.Program Name",
         programEnrolment.id                                                                    "Enl.Id",
         programEnrolment.uuid                                                                  "Enl.uuid",
         programEnrolment.is_voided                                                             "Enl.is_voided",
         oet.name                                                                               "Enc.Type",
         programEncounter.id                                                                    "Enc.Id",
         programEncounter.earliest_visit_date_time                                              "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                                   "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                                  "Enc.program_enrolment_id",
         programEncounter.uuid                                                                  "Enc.uuid",
         programEncounter.name                                                                  "Enc.name",
         programEncounter.max_visit_date_time                                                   "Enc.max_visit_date_time",
         programEncounter.is_voided                                                             "Enc.is_voided",
         get_coded_string_value(
             individual.observations -> 'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT       as "Ind.Marital status",
         (individual.observations ->> 'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT          as "Ind.Number of family members",
         get_coded_string_value(
             individual.observations -> 'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT       as "Ind.Who is decision making person in family",
         get_coded_string_value(
             individual.observations -> '8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT       as "Ind.Ration card",
         get_coded_string_value(
             individual.observations -> 'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT       as "Ind.Caste",
         get_coded_string_value(
             individual.observations -> '5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT       as "Ind.Subcaste",
         get_coded_string_value(
             individual.observations -> 'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT       as "Ind.Religion",
         get_coded_string_value(
             individual.observations -> '4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT       as "Ind.Satipati family",
         get_coded_string_value(
             individual.observations -> '0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT       as "Ind.Addiction",
         get_coded_string_value(
             individual.observations -> 'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT        as "Ind.Addiction - Please specify",
         get_coded_string_value(
             individual.observations -> '89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT       as "Ind.Very poor family",
         get_coded_string_value(
             individual.observations -> '6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT       as "Ind.Occupation of mother",
         get_coded_string_value(
             individual.observations -> '65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT       as "Ind.Occupation of husband/father",
         get_coded_string_value(
             individual.observations -> 'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT       as "Ind.Mother's education",
         (individual.observations ->> '881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT          as "Ind.Mobile number",
         get_coded_string_value(
             individual.observations -> '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT       as "Ind.Specialy abled",
         get_coded_string_value(
             individual.observations -> 'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT       as "Ind.Specially abled - Please specify",
         get_coded_string_value(
             individual.observations -> 'd009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT       as "Ind.Any long-term illnesses",
         get_coded_string_value(
             individual.observations -> '7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT        as "Ind.Long-term illness - Please specify",
         get_coded_string_value(
             individual.observations -> '54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT       as "Ind.Toilet facility present",
         get_coded_string_value(
             individual.observations -> '59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT       as "Ind.Using the toilet regularly",
         get_coded_string_value(
             individual.observations -> '789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT        as "Ind.Source of drinking water",
         get_coded_string_value(
             programEnrolment.observations -> 'f1a9ede3-1b9b-4b1a-a8fb-6a3bb8f1cc19', concepts.map)::TEXT as "Enl.Is child getting registered at Birth",
         (programEnrolment.observations ->> 'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT    as "Enl.Weight",
         (programEnrolment.observations ->> 'c82cd1c8-d0a9-4237-b791-8d64e52b6c4a')::TEXT    as "Enl.Birth Weight",
         get_coded_string_value(
             programEncounter.observations -> 'a9002492-13f9-4778-8082-2d8d58862912', concepts.map)::TEXT as "Enc.Place of Birth",
         (programEncounter.observations ->> 'c82cd1c8-d0a9-4237-b791-8d64e52b6c4a')::TEXT    as "Enc.Birth Weight",
         get_coded_string_value(
             programEncounter.observations -> '01168515-86a6-4ddf-beb9-13c80ff2aaa1', concepts.map)::TEXT as "Enc.Gestational age category at birth",
         get_coded_string_value(
             programEncounter.observations -> 'dffe45ff-7784-4fb9-96a0-83fa0ed4420d', concepts.map)::TEXT as "Enc.Did the baby cry soon after birth?",
         get_coded_string_value(
             programEncounter.observations -> '90086c0d-33a6-4044-b3e8-bbef93796517', concepts.map)::TEXT as "Enc.Did breast feeding start within 1 hour of birth?",
         (programEncounter.observations ->> '38ca808e-8247-4c89-aee2-494262b2cc43')::TEXT    as "Enc.When did breast feeding start?",
         get_coded_string_value(
             programEncounter.observations -> '5f42d5e5-8405-40ae-ab2f-77b5992e7359', concepts.map)::TEXT as "Enc.Was colostrum given?",
         get_coded_string_value(
             programEncounter.observations -> '4a24ed38-5d6c-4c77-8574-aed4ccaa4537', concepts.map)::TEXT as "Enc.Was any kind of sweet liquid tried to child?",
         get_coded_string_value(
             programEncounter.observations -> '37a2e804-b377-4a94-8628-252a6ae83b67', concepts.map)::TEXT as "Enc.Was child wrapped in 3-4 folded clothes?",
         multi_select_coded(
             programEncounter.observations -> 'a6ad7816-154d-4007-8fb5-ef36ed19af95')::TEXT  as "Enc.Birth Defects",
         (programEncounter.observations ->> '959ad8b6-2388-4b15-8bce-bd511fb97815')::TEXT    as "Enc.Other Birth Defect",
         get_coded_string_value(
             programEncounter.observations -> '35870e21-f4a7-4df1-980a-b77954928f66', concepts.map)::TEXT as "Enc.Colour of child",
         get_coded_string_value(
             programEncounter.observations -> 'b0306743-3879-46f0-b963-f41447d1891b', concepts.map)::TEXT as "Enc.Icterus present within 24 hrs of birth?",
         get_coded_string_value(
             programEncounter.observations -> '397e9057-446b-4076-8676-92b79281601b', concepts.map)::TEXT as "Enc.Is child breathing regularly?",
         get_coded_string_value(
             programEncounter.observations -> '92264531-33df-4ad3-97ce-89ef2a9eb514', concepts.map)::TEXT as "Enc.Is there life threatening abnormality?",
         get_coded_string_value(
             programEncounter.observations -> '9f3a91ea-7e87-4cb7-b40c-426d20adc737', concepts.map)::TEXT as "Enc.Is foam coming out from child's mouth?",
         get_coded_string_value(
             programEncounter.observations -> '737ae4e7-f38a-4aef-a6aa-d9ad1642494a', concepts.map)::TEXT as "Enc.Is any kind of cyst or tumor present on neck, back and on lower back?",
         get_coded_string_value(
             programEncounter.observations -> 'e1711f03-e9ff-4356-b018-5f08c1ee6207', concepts.map)::TEXT as "Enc.Is umbelical cord of newborn tied properly?",
         get_coded_string_value(
             programEncounter.observations -> '09573558-edb4-41c6-a2a7-55484158c96e', concepts.map)::TEXT as "Enc.Is blood coming out from any part of body?",
         (programEncounter.observations ->> 'b0b2e912-5433-4594-8d86-2098c57d671a')::TEXT    as "Enc.Temperature of infant",
         (programEncounter.observations ->> '20401dea-a7ee-480a-8980-6cb419f732fe')::TEXT    as "Enc.Child Respiratory Rate",
         programEncounter.cancel_date_time                                                      "EncCancel.cancel_date_time",
         get_coded_string_value(
             programEncounter.observations -> '0066a0f7-c087-40f4-ae44-a3e931967767', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
         (programEncounter.observations ->> 'fadd881a-beed-47ea-a4d6-700009a61a32')::TEXT    as "EncCancel.Other reason for cancelling",
         get_coded_string_value(
             programEncounter.observations -> 'dde645f5-0f70-45e9-a670-b7190c86c981', concepts.map)::TEXT as "EncCancel.Place of death",
         (programEncounter.observations ->> '3b269f11-ed0a-4636-8273-da0259783214')::DATE    as "EncCancel.Date of death",
         get_coded_string_value(
             programEncounter.observations -> '7c88aea6-dfed-451e-a086-881e2dcfd85f', concepts.map)::TEXT as "EncCancel.Reason of death"
  FROM program_encounter programEncounter
         CROSS JOIN concepts
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id
  WHERE op.uuid = '70e4db05-c79a-406c-89be-54f8d77f643a'
    AND oet.uuid = '8ffacbcf-518f-45eb-a524-a425a36aab3f'
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jnpct_child_enrolment_view;
create view jnpct_child_enrolment_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
  SELECT individual.id                                                                          "Ind.Id",
         individual.address_id                                                                  "Ind.address_id",
         individual.uuid                                                                        "Ind.uuid",
         individual.first_name                                                                  "Ind.first_name",
         individual.last_name                                                                   "Ind.last_name",
         g.name                                                                                 "Ind.Gender",
         individual.date_of_birth                                                               "Ind.date_of_birth",
         individual.date_of_birth_verified                                                      "Ind.date_of_birth_verified",
         individual.registration_date                                                           "Ind.registration_date",
         individual.facility_id                                                                 "Ind.facility_id",
         village.title                                                                          "Ind.village",
         subcenter.title                                                                        "Ind.subcenter",
         phc.title                                                                              "Ind.phc",
         block.title                                                                            "Ind.block",
         individual.is_voided                                                                   "Ind.is_voided",
         op.name                                                                                "Enl.Program Name",
         programEnrolment.id                                                                    "Enl.Id",
         programEnrolment.enrolment_date_time                                                   "Enl.enrolment_date_time",
         programEnrolment.program_exit_date_time                                                "Enl.program_exit_date_time",
         programEnrolment.uuid                                                                  "Enl.uuid",
         programEnrolment.is_voided                                                             "Enl.is_voided",
         get_coded_string_value(
             individual.observations -> 'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT       as "Ind.Marital status",
         (individual.observations ->> 'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT          as "Ind.Number of family members",
         get_coded_string_value(
             individual.observations -> 'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT       as "Ind.Who is decision making person in family",
         get_coded_string_value(
             individual.observations -> '8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT       as "Ind.Ration card",
         get_coded_string_value(
             individual.observations -> 'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT       as "Ind.Caste",
         get_coded_string_value(
             individual.observations -> '5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT       as "Ind.Subcaste",
         get_coded_string_value(
             individual.observations -> 'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT       as "Ind.Religion",
         get_coded_string_value(
             individual.observations -> '4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT       as "Ind.Satipati family",
         get_coded_string_value(
             individual.observations -> '0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT       as "Ind.Addiction",
         get_coded_string_value(
             individual.observations -> 'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT        as "Ind.Addiction - Please specify",
         get_coded_string_value(
             individual.observations -> '89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT       as "Ind.Very poor family",
         get_coded_string_value(
             individual.observations -> '6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT       as "Ind.Occupation of mother",
         get_coded_string_value(
             individual.observations -> '65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT       as "Ind.Occupation of husband/father",
         get_coded_string_value(
             individual.observations -> 'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT       as "Ind.Mother's education",
         (individual.observations ->> '881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT          as "Ind.Mobile number",
         get_coded_string_value(
             individual.observations -> '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT       as "Ind.Specialy abled",
         get_coded_string_value(
             individual.observations -> 'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT       as "Ind.Specially abled - Please specify",
         get_coded_string_value(
             individual.observations -> 'd009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT       as "Ind.Any long-term illnesses",
         get_coded_string_value(
             individual.observations -> '7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT        as "Ind.Long-term illness - Please specify",
         get_coded_string_value(
             individual.observations -> '54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT       as "Ind.Toilet facility present",
         get_coded_string_value(
             individual.observations -> '59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT       as "Ind.Using the toilet regularly",
         get_coded_string_value(
             individual.observations -> '789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT        as "Ind.Source of drinking water",
         get_coded_string_value(
             programEnrolment.observations -> 'f1a9ede3-1b9b-4b1a-a8fb-6a3bb8f1cc19', concepts.map)::TEXT as "Enl.Is child getting registered at Birth",
         (programEnrolment.observations ->> 'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT    as "Enl.Weight",
         (programEnrolment.observations ->> 'c82cd1c8-d0a9-4237-b791-8d64e52b6c4a')::TEXT    as "Enl.Birth Weight"

  FROM program_enrolment programEnrolment
         CROSS JOIN concepts
         LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id
  WHERE op.uuid = '70e4db05-c79a-406c-89be-54f8d77f643a'
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jnpct_child_pnc_view;
create view jnpct_child_pnc_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
  SELECT individual.id                                                                          "Ind.Id",
         individual.address_id                                                                  "Ind.address_id",
         individual.uuid                                                                        "Ind.uuid",
         individual.first_name                                                                  "Ind.first_name",
         individual.last_name                                                                   "Ind.last_name",
         g.name                                                                                 "Ind.Gender",
         individual.date_of_birth                                                               "Ind.date_of_birth",
         individual.date_of_birth_verified                                                      "Ind.date_of_birth_verified",
         individual.registration_date                                                           "Ind.registration_date",
         individual.facility_id                                                                 "Ind.facility_id",
         village.title                                                                             AS "Ind.village",
         subcenter.title                                                                           AS "Ind.subcenter",
         phc.title                                                                                 AS "Ind.phc",
         block.title                                                                               AS "Ind.block",
         individual.is_voided                                                                   "Ind.is_voided",
         op.name                                                                                "Enl.Program Name",
         programEnrolment.id                                                                    "Enl.Id",
         programEnrolment.enrolment_date_time                                                   "Enl.enrolment_date_time",
         programEnrolment.program_exit_date_time                                                "Enl.program_exit_date_time",
         programEnrolment.uuid                                                                  "Enl.uuid",
         programEnrolment.is_voided                                                             "Enl.is_voided",
         oet.name                                                                               "Enc.Type",
         programEncounter.id                                                                    "Enc.Id",
         programEncounter.earliest_visit_date_time                                              "Enc.earliest_visit_date_time",
         programEncounter.encounter_date_time                                                   "Enc.encounter_date_time",
         programEncounter.program_enrolment_id                                                  "Enc.program_enrolment_id",
         programEncounter.uuid                                                                  "Enc.uuid",
         programEncounter.name                                                                  "Enc.name",
         programEncounter.max_visit_date_time                                                   "Enc.max_visit_date_time",
         programEncounter.is_voided                                                             "Enc.is_voided",
         get_coded_string_value(
             individual.observations -> 'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT       as "Ind.Marital status",
         (individual.observations ->> 'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT          as "Ind.Number of family members",
         get_coded_string_value(
             individual.observations -> 'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT       as "Ind.Who is decision making person in family",
         get_coded_string_value(
             individual.observations -> '8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT       as "Ind.Ration card",
         get_coded_string_value(
             individual.observations -> 'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT       as "Ind.Caste",
         get_coded_string_value(
             individual.observations -> '5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT       as "Ind.Subcaste",
         get_coded_string_value(
             individual.observations -> 'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT       as "Ind.Religion",
         get_coded_string_value(
             individual.observations -> '4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT       as "Ind.Satipati family",
         get_coded_string_value(
             individual.observations -> '0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT       as "Ind.Addiction",
         get_coded_string_value(
             individual.observations -> 'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT        as "Ind.Addiction - Please specify",
         get_coded_string_value(
             individual.observations -> '89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT       as "Ind.Very poor family",
         get_coded_string_value(
             individual.observations -> '6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT       as "Ind.Occupation of mother",
         get_coded_string_value(
             individual.observations -> '65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT       as "Ind.Occupation of husband/father",
         get_coded_string_value(
             individual.observations -> 'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT       as "Ind.Mother's education",
         (individual.observations ->> '881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT          as "Ind.Mobile number",
         get_coded_string_value(
             individual.observations -> '5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT       as "Ind.Specialy abled",
         get_coded_string_value(
             individual.observations -> 'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT       as "Ind.Specially abled - Please specify",
         get_coded_string_value(
             individual.observations -> 'd009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT       as "Ind.Any long-term illnesses",
         get_coded_string_value(
             individual.observations -> '7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT        as "Ind.Long-term illness - Please specify",
         get_coded_string_value(
             individual.observations -> '54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT       as "Ind.Toilet facility present",
         get_coded_string_value(
             individual.observations -> '59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT       as "Ind.Using the toilet regularly",
         get_coded_string_value(
             individual.observations -> '789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT        as "Ind.Source of drinking water",
         get_coded_string_value(
             programEnrolment.observations -> 'f1a9ede3-1b9b-4b1a-a8fb-6a3bb8f1cc19', concepts.map)::TEXT as "Enl.Is child getting registered at Birth",
         (programEnrolment.observations ->> 'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT    as "Enl.Weight",
         (programEnrolment.observations ->> 'c82cd1c8-d0a9-4237-b791-8d64e52b6c4a')::TEXT    as "Enl.Birth Weight",
         get_coded_string_value(
             programEncounter.observations -> '6c3250f8-8380-4f72-97e7-d5ce9e41338a', concepts.map)::TEXT as "Enc.Whether child breathing regularly?",
         get_coded_string_value(
             programEncounter.observations -> 'e401ebe8-07e0-4f34-bcf8-8a8c3eaf3b9d', concepts.map)::TEXT as "Enc.Is the child pinkish in colour?",
         get_coded_string_value(
             programEncounter.observations -> '7ee92cf1-1661-420f-8eaf-9b7249779058', concepts.map)::TEXT as "Enc.Is body temprature warm?",
         get_coded_string_value(
             programEncounter.observations -> 'bb279686-d296-4378-858a-f88532454430', concepts.map)::TEXT as "Enc.Is there active movement of hands and legs?",
         get_coded_string_value(
             programEncounter.observations -> '186e42dc-515f-4415-8a48-e7709123c060', concepts.map)::TEXT as "Enc.Is there any life threatening abnormality?",
         get_coded_string_value(
             programEncounter.observations -> '0277a00d-20d5-436e-8070-205d29a458d2', concepts.map)::TEXT as "Enc.Examine for cleft palate/lips in child's mouth?",
         get_coded_string_value(
             programEncounter.observations -> '23456b1a-29bb-4a16-952c-9476f7751dd0', concepts.map)::TEXT as "Enc.Does foam coming out from child's mouth?",
         get_coded_string_value(
             programEncounter.observations -> 'b6930840-0515-4805-8ade-30431f95122e', concepts.map)::TEXT as "Enc.Does child paases stool and urine within 24  hour",
         get_coded_string_value(
             programEncounter.observations -> 'f51ec371-e402-4ce6-b680-7d82002f1717', concepts.map)::TEXT as "Enc.Is there anal opening present?",
         get_coded_string_value(
             programEncounter.observations -> '972d4847-b8d4-49cc-b0ae-b3fbe4125283', concepts.map)::TEXT as "Enc.Does any kind of cyst or tumor present on neck, back and on lower back?",
         get_coded_string_value(
             programEncounter.observations -> '714fc100-13c3-418c-aa76-e2ca24e0d6f3', concepts.map)::TEXT as "Enc.Does umbelical cord of newborn tied properly?",
         get_coded_string_value(
             programEncounter.observations -> '60746eac-8f88-4c59-b107-bb8f64406f1f', concepts.map)::TEXT as "Enc.Is blood coming out from any part of body ( cord ,head ,mouth, anus )?",
         get_coded_string_value(
             programEncounter.observations -> '648faf63-17f1-4ec6-a9b9-78d1edb4061a', concepts.map)::TEXT as "Enc.Is there visible jaundice?",
         get_coded_string_value(
             programEncounter.observations -> 'd48fca1d-8344-499c-bcf7-86ce64606f74', concepts.map)::TEXT as "Enc.Does infant has any problem now?",
         (programEncounter.observations ->> '96ded0c5-3937-40b7-ab27-7a82126bd60c')::TEXT    as "Enc.Problem with infant",
         (programEncounter.observations ->> '20401dea-a7ee-480a-8980-6cb419f732fe')::TEXT    as "Enc.Child Respiratory Rate",
         get_coded_string_value(
             programEncounter.observations -> '58d017ed-56e3-426c-add1-e06f2af19e01', concepts.map)::TEXT as "Enc.Is there any grunting sound?",
         get_coded_string_value(
             programEncounter.observations -> '3f8b75b0-41aa-4f38-82bd-459ac8b8fa37', concepts.map)::TEXT as "Enc.Is there chest indrawing?",
         get_coded_string_value(
             programEncounter.observations -> 'bc9c3023-5d55-4172-a883-f83ab449deff', concepts.map)::TEXT as "Enc.Is there nasal flaring?",
         get_coded_string_value(
             programEncounter.observations -> '56aec7ea-d2aa-4439-a531-59d0acc402dd', concepts.map)::TEXT as "Enc.How is the colour of infant",
         get_coded_string_value(
             programEncounter.observations -> 'db74f827-c052-4c0a-9df3-9d34dcddea6f', concepts.map)::TEXT as "Enc.Look at the infants movement",
         get_coded_string_value(
             programEncounter.observations -> 'e58035a6-32f4-4728-8ebb-7a8ab3e1b082', concepts.map)::TEXT as "Enc.Is anything applied on umbelicus?",
         get_coded_string_value(
             programEncounter.observations -> '90c1f569-76e9-433c-a0fe-096d179ef8de', concepts.map)::TEXT as "Enc.Is infant coverred with 3-4 folded cloth?",
         get_coded_string_value(
             programEncounter.observations -> 'cdf5f2b6-ec61-4dc3-8260-61960d1239ce', concepts.map)::TEXT as "Enc.Is temperature recorded?",
         (programEncounter.observations ->> 'b0b2e912-5433-4594-8d86-2098c57d671a')::TEXT    as "Enc.Temperature of infant",
         get_coded_string_value(
             programEncounter.observations -> '9a5019fa-cd87-441c-8b8c-f2373987178f', concepts.map)::TEXT as "Enc.Reason for not recording temperature",
         get_coded_string_value(
             programEncounter.observations -> 'cadf0874-1446-411a-9e97-cf8a67a234e1', concepts.map)::TEXT as "Enc.How you feel infants temprature on touch?",
         get_coded_string_value(
             programEncounter.observations -> 'df75e2e6-4d5f-4ed8-a24e-14ce72da1e10', concepts.map)::TEXT as "Enc.Condition of umbelicus",
         (programEncounter.observations ->> 'bc203ffc-00bf-42ed-988c-97cc954d1061')::TEXT    as "Enc.When was first breastfeed given to child?",
         get_coded_string_value(
             programEncounter.observations -> '60baea86-df95-443c-bac4-852482d2b2a8', concepts.map)::TEXT as "Enc.How is the infant attachment while sucking?",
         get_coded_string_value(
             programEncounter.observations -> '5e309ac3-1b96-4965-a94a-2341f834a7c0', concepts.map)::TEXT as "Enc.Is mouth wide open",
         get_coded_string_value(
             programEncounter.observations -> '80144e66-99dc-4404-bacc-f33554ea97fb', concepts.map)::TEXT as "Enc.Is lower lip turned outword",
         get_coded_string_value(
             programEncounter.observations -> 'dc5da243-4e23-48b7-b5e5-e2cc18a7680e', concepts.map)::TEXT as "Enc.Is chin attached to breast?",
         get_coded_string_value(
             programEncounter.observations -> '144796e8-cfcd-47dd-befc-bf62a3f87056', concepts.map)::TEXT as "Enc.Is more areola visible above than below the mouth",
         get_coded_string_value(
             programEncounter.observations -> '26d47b4e-9b2f-45bd-9044-41596b330183', concepts.map)::TEXT as "Enc.Is there anything given other than breastfeeding for infant",
         multi_select_coded(
             programEncounter.observations -> '8c96d4e2-efd5-4886-acc6-e9438522a25b')::TEXT  as "Enc.Things given other than bresatfeeding",
         get_coded_string_value(
             programEncounter.observations -> 'd5993485-2b05-4ef8-a980-0f62a9e2b3e4', concepts.map)::TEXT as "Enc.Does infant has any difficulty in breastfeeding?",
         get_coded_string_value(
             programEncounter.observations -> '4f440c38-c2f8-4489-9b98-53e7faebb9f5', concepts.map)::TEXT as "Enc.Is breastfeed given to infant in last 24 hours?",
         (programEncounter.observations ->> '6ca3c61e-2dda-49ad-a9b4-7eb719874c27')::TEXT    as "Enc.How many times breastfeeding given to child in last 24 hours",
         get_coded_string_value(
             programEncounter.observations -> 'fff940b1-7cfc-40b1-8145-1fa3794ebdcd', concepts.map)::TEXT as "Enc.In last 24 hours, for how many times infant passes urine?",
         get_coded_string_value(
             programEncounter.observations -> '8c18e07c-ca8f-4f62-823d-1618fac5912c', concepts.map)::TEXT as "Enc.When to start bathing for infant?",
         get_coded_string_value(
             programEncounter.observations -> 'f4d9696d-9075-4b32-bc6a-3f33fd19ef40', concepts.map)::TEXT as "Enc.Is there bleeding from any part of infant's body?",
         get_coded_string_value(
             programEncounter.observations -> '09b4ee52-8d80-48f5-84dd-e375e16bbda9', concepts.map)::TEXT as "Enc.Is infant vomiting?",
         get_coded_string_value(
             programEncounter.observations -> '57bf7e17-a75d-4141-ae61-5f9a10b67527', concepts.map)::TEXT as "Enc.Does infant's abdomen look gasious?",
         get_coded_string_value(
             programEncounter.observations -> 'bbf0e17f-769e-4389-82e5-01eccb0c745c', concepts.map)::TEXT as "Enc.Does infant looks icteric?",
         get_coded_string_value(
             programEncounter.observations -> 'cfba52eb-6f92-4db8-a42c-8a3623e15bde', concepts.map)::TEXT as "Enc.Does infant looks cynosed?",
         get_coded_string_value(
             programEncounter.observations -> 'd350f4e7-0d54-44d3-aeb0-e47b898b2e8d', concepts.map)::TEXT as "Enc.Does infant looks abnormal?",
         get_coded_string_value(
             programEncounter.observations -> 'b2097167-c02d-4d2d-a9ec-49614027a5ea', concepts.map)::TEXT as "Enc.Is the infant's mouth cleft pallet seen?",
         get_coded_string_value(
             programEncounter.observations -> '4b225831-3670-4537-b663-90c87c417f98', concepts.map)::TEXT as "Enc.Is there visible tumor on back or on head of infant?",
         get_coded_string_value(
             programEncounter.observations -> 'ee670016-5517-4c10-a27a-998bbd94247e', concepts.map)::TEXT as "Enc.Is foam coming from infant's mouth continuously?",
         get_coded_string_value(
             programEncounter.observations -> '477207cd-61ef-46ed-b28d-1c2be3eb6415', concepts.map)::TEXT as "Enc.Does infant has watery diarrhoea?",
         (programEncounter.observations ->> '4c7b1f17-380f-422b-85b7-a85f95e040d3')::TEXT    as "Enc.If yes, then since how many does infant has watery diarrhoea",
         get_coded_string_value(
             programEncounter.observations -> 'f0bdf6d9-a8f8-439c-88fc-7be3c00e8de1', concepts.map)::TEXT as "Enc.Is oral ulcer or thrush seen in infant's mouth",
         get_coded_string_value(
             programEncounter.observations -> 'c9468105-56fa-4e41-8ed0-943d106c040e', concepts.map)::TEXT as "Enc.Is there visible pustules on body of infant?",
         get_coded_string_value(
             programEncounter.observations -> '6b66b89e-e7f6-470c-be4e-1f236d15af90', concepts.map)::TEXT as "Enc.If yes, then how many visible pustules are on the body",
         (programEncounter.observations ->> 'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT    as "Enc.Weight",
         (programEncounter.observations ->> '3fb85722-fd53-43db-9e8b-d34767af9f7e')::TEXT    as "Enc.Nutritional status of child",
         get_coded_string_value(
             programEncounter.observations -> 'd21d1844-362b-426c-a5d4-c45ab5fc1690', concepts.map)::TEXT as "Enc.If infant's weight is less than 2.5kg then did KMC?",
         (programEncounter.observations ->> '81d81392-d0e6-40ce-84bd-4fd0eba04719')::TEXT    as "Enc.Weight at the time of KMC started to do",
         (programEncounter.observations ->> '4f2cae52-9923-44f3-baf5-b03a62423acb')::TEXT    as "Enc.In last 24 hours for how many times did KMC?",
         (programEncounter.observations ->> '29d4737c-15b3-42f2-b296-632fee9f5fe7')::TEXT    as "Enc.In one time for how many minutes did KMC?",
         (programEncounter.observations ->> '78511bef-1c10-47a0-98cb-a91aff6f1c3c')::TEXT    as "Enc.Weight of infant at time to stoped to do KMC",
         get_coded_string_value(
             programEncounter.observations -> 'e8a74be5-e817-4992-87df-abab41753f38', concepts.map)::TEXT as "Enc.Does child require to refer if morbidity found",
         get_coded_string_value(
             programEncounter.observations -> '61be533a-98a6-4a73-919f-79c1f4fd4cfc', concepts.map)::TEXT as "Enc.If yes then refered?",
         (programEncounter.observations ->> 'ca103da5-3221-487c-b687-4f43bc434c0c')::DATE    as "Enc.Date of refer",
         get_coded_string_value(
             programEncounter.observations -> '1aa46e35-6256-40cd-a026-8c825565a98f', concepts.map)::TEXT as "Enc.Who refered?",
         get_coded_string_value(
             programEncounter.observations -> '38fa0a7d-7bb6-4e84-a5d8-2b1b9c463f6b', concepts.map)::TEXT as "Enc.Place of refer",
         get_coded_string_value(
             programEncounter.observations -> 'f006c0b1-d6ad-44b4-b347-0f8ba148048d', concepts.map)::TEXT as "Enc.Baby Warming Dos",
         get_coded_string_value(
             programEncounter.observations -> '3657a1ae-83cb-4204-82b0-0745d29541c2', concepts.map)::TEXT as "Enc.Breast Feeding - Do's",
         get_coded_string_value(
             programEncounter.observations -> 'cddc0438-74a1-4bcb-843c-34a47da7c1e4', concepts.map)::TEXT as "Enc.Hygiene advice",
         get_coded_string_value(
             programEncounter.observations -> '063fd686-1070-405b-89a6-cbf5e3c79f0f', concepts.map)::TEXT as "Enc.Child PNC Weight -Do's",
         get_coded_string_value(
             programEncounter.observations -> 'c13e5e72-2c93-4462-be0b-010263bb2e02', concepts.map)::TEXT as "Enc.Registration Immunisation - Do's",
         programEncounter.cancel_date_time                                                      "EncCancel.cancel_date_time",
         get_coded_string_value(
             programEncounter.observations -> '0066a0f7-c087-40f4-ae44-a3e931967767', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
         (programEncounter.observations ->> 'fadd881a-beed-47ea-a4d6-700009a61a32')::TEXT    as "EncCancel.Other reason for cancelling",
         get_coded_string_value(
             programEncounter.observations -> 'dde645f5-0f70-45e9-a670-b7190c86c981', concepts.map)::TEXT as "EncCancel.Place of death",
         (programEncounter.observations ->> '3b269f11-ed0a-4636-8273-da0259783214')::DATE    as "EncCancel.Date of death",
         get_coded_string_value(
             programEncounter.observations -> '7c88aea6-dfed-451e-a086-881e2dcfd85f', concepts.map)::TEXT as "EncCancel.Reason of death"
  FROM program_encounter programEncounter
         CROSS JOIN concepts
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment
                         ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id

  WHERE op.uuid = '70e4db05-c79a-406c-89be-54f8d77f643a'
    AND (oet.uuid = '659323b5-b9b8-41d8-b4e6-223c33d25495' OR oet.uuid = '6d785d7a-67ae-4e27-b646-8a35082ded9d')
    AND programEncounter.encounter_date_time IS NOT NULL
    AND programEnrolment.enrolment_date_time IS NOT NULL
);

drop view if exists jnpct_child_followup_view;
create view jnpct_child_followup_view as (
with concepts as (select hstore(array_agg(uuid), array_agg(name)) map from concept)
SELECT  individual.id "Ind.Id",
        individual.address_id "Ind.address_id",
        individual.uuid "Ind.uuid",
        individual.first_name "Ind.first_name",
        individual.last_name "Ind.last_name",
        g.name "Ind.Gender",
        individual.date_of_birth "Ind.date_of_birth",
        individual.date_of_birth_verified "Ind.date_of_birth_verified",
        individual.registration_date "Ind.registration_date",
        individual.facility_id  "Ind.facility_id",
        village.title             "Ind.village",
        subcenter.title           "Ind.subcenter",
        phc.title                 "Ind.phc",
        block.title               "Ind.block",
        individual.is_voided "Ind.is_voided",
        op.name "Enl.Program Name",
        programEnrolment.id  "Enl.Id",
        programEnrolment.uuid  "Enl.uuid",
        programEnrolment.is_voided "Enl.is_voided",
        oet.name "Enc.Type",
        programEncounter.id "Enc.Id",
        programEncounter.earliest_visit_date_time "Enc.earliest_visit_date_time",
        programEncounter.encounter_date_time "Enc.encounter_date_time",
        programEncounter.program_enrolment_id "Enc.program_enrolment_id",
        programEnrolment.enrolment_date_time "Enl.enrolment_date_time",
        programEnrolment.program_exit_date_time  "Enl.program_exit_date_time",
        programEncounter.uuid "Enc.uuid",
        programEncounter.name "Enc.name",
        programEncounter.max_visit_date_time "Enc.max_visit_date_time",
        programEncounter.is_voided "Enc.is_voided",
        get_coded_string_value(individual.observations->'a20a030b-9bef-4ef8-ba8a-88e2b23c1478', concepts.map)::TEXT as "Ind.Marital status",
        (individual.observations->>'a01c2055-7483-4a19-98c1-80fdf955b50c')::TEXT as "Ind.Number of family members",
        get_coded_string_value(individual.observations->'f4028968-bbac-4a66-8fe7-df081321414f', concepts.map)::TEXT as "Ind.Who is decision making person in family",
        get_coded_string_value(individual.observations->'8eb5a6ce-7b8a-45cc-a066-fcceca3708f7', concepts.map)::TEXT as "Ind.Ration card",
        get_coded_string_value(individual.observations->'ba25ac4c-784a-4723-8e15-a965a0d63b50', concepts.map)::TEXT as "Ind.Caste",
        get_coded_string_value(individual.observations->'5f20070c-1cfe-4e0b-b0db-70dffee99394', concepts.map)::TEXT as "Ind.Subcaste",
        get_coded_string_value(individual.observations->'b9c9d807-7064-46fd-8dc7-1640345dc8cb', concepts.map)::TEXT as "Ind.Religion",
        get_coded_string_value(individual.observations->'4e90fc18-7bf1-4722-87c3-f3b2bd5d1d7d', concepts.map)::TEXT as "Ind.Satipati family",
        get_coded_string_value(individual.observations->'0a668e5b-f3c2-4fc6-8589-d2abda26658b', concepts.map)::TEXT as "Ind.Addiction",
        get_coded_string_value(individual.observations->'e0a3086c-8d69-479e-bf44-258bc27b8105', concepts.map)::TEXT as "Ind.Addiction - Please specify",
        get_coded_string_value(individual.observations->'89fe78b2-20a9-45f1-90e3-119a7bc95ce3', concepts.map)::TEXT as "Ind.Very poor family",
        get_coded_string_value(individual.observations->'6f03e969-f0bf-4438-a528-5d2ce3b70e15', concepts.map)::TEXT as "Ind.Occupation of mother",
        get_coded_string_value(individual.observations->'65a5101b-38fc-4962-876e-e0f8b9ba4cec', concepts.map)::TEXT as "Ind.Occupation of husband/father",
        get_coded_string_value(individual.observations->'e42f5b28-bee4-4a01-aff0-922d823d0075', concepts.map)::TEXT as "Ind.Mother's education",
        (individual.observations->>'881d9628-eb4f-4056-ae10-09e4ef71cae4')::TEXT as "Ind.Mobile number",
        get_coded_string_value(individual.observations->'5f0b2fa0-ed20-4d6b-a8b5-3fed09dac067', concepts.map)::TEXT as "Ind.Specialy abled",
        get_coded_string_value(individual.observations->'a154508a-9d8b-49d9-9d78-b61cbc9daf7f', concepts.map)::TEXT as "Ind.Specially abled - Please specify",
        get_coded_string_value(individual.observations->'d009887c-6d29-4c47-9e34-21e3b9298f44', concepts.map)::TEXT as "Ind.Any long-term illnesses",
        get_coded_string_value(individual.observations->'7fa81959-a016-4569-920d-47dee242b27a', concepts.map)::TEXT as "Ind.Long-term illness - Please specify",
        get_coded_string_value(individual.observations->'54105452-1752-4661-9d30-2d99bd2d04fa', concepts.map)::TEXT as "Ind.Toilet facility present",
        get_coded_string_value(individual.observations->'59db93f0-0963-4e49-87b6-485efb705561', concepts.map)::TEXT as "Ind.Using the toilet regularly",
        get_coded_string_value(individual.observations->'789733c4-42ba-4da3-89e6-71da227cf4c2', concepts.map)::TEXT as "Ind.Source of drinking water",
        get_coded_string_value(programEnrolment.observations->'f1a9ede3-1b9b-4b1a-a8fb-6a3bb8f1cc19', concepts.map)::TEXT as "Enl.Is child getting registered at Birth",
        (programEnrolment.observations->>'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT as "Enl.Weight",
        (programEnrolment.observations->>'c82cd1c8-d0a9-4237-b791-8d64e52b6c4a')::TEXT as "Enl.Birth Weight",
        get_coded_string_value(programEncounter.observations->'2c450841-582e-4612-ad9c-8fdcaa0ce969', concepts.map)::TEXT as "Enc.Ask the mother now: Child has any problem",
        (programEncounter.observations->>'5847a83b-84e7-4119-abfc-bf2a0354c7e9')::TEXT as "Enc.Then write the problem",
        get_coded_string_value(programEncounter.observations->'8de443e5-60ab-458c-b7d6-961dff4e2635', concepts.map)::TEXT as "Enc.Is the child able to drink or breastfeed",
        get_coded_string_value(programEncounter.observations->'7f5d6e16-2e84-40cd-b459-0cde857f2b49', concepts.map)::TEXT as "Enc.Does the child vomits everything",
        get_coded_string_value(programEncounter.observations->'fbf27f7e-ddd8-4c8f-ad93-70cd0114bd7c', concepts.map)::TEXT as "Enc.Has the child had convulsion",
        get_coded_string_value(programEncounter.observations->'cc36f402-2fff-48ef-8643-a017955b731e', concepts.map)::TEXT as "Enc.See the child is lethargic or unconsious",
        get_coded_string_value(programEncounter.observations->'591b7d38-343f-436f-a695-7679b27b3d24', concepts.map)::TEXT as "Enc.Is there general danger sign",
        get_coded_string_value(programEncounter.observations->'23db49c5-072f-4df9-bb74-9d07da2bb4d3', concepts.map)::TEXT as "Enc.child is referred?",
        get_coded_string_value(programEncounter.observations->'35f5c273-5abe-4bb6-838c-52e844040a57', concepts.map)::TEXT as "Enc.Does the child have cough or difficult breathing",
        (programEncounter.observations->>'93d6cded-aea1-42ce-8833-be70340d0df9')::TEXT as "Enc.Since how many days",
        (programEncounter.observations->>'20401dea-a7ee-480a-8980-6cb419f732fe')::TEXT as "Enc.Child Respiratory Rate",
        get_coded_string_value(programEncounter.observations->'47643574-084a-4060-8bb9-46d8910e5dfa', concepts.map)::TEXT as "Enc.Does the child has fast breathing",
        get_coded_string_value(programEncounter.observations->'e992edc8-5886-4b20-8a76-4597e94bfa78', concepts.map)::TEXT as "Enc.look for chest indrwaning",
        get_coded_string_value(programEncounter.observations->'3432fca6-bd23-41aa-9f99-f6851c11609d', concepts.map)::TEXT as "Enc.does child has diorrhea",
        (programEncounter.observations->>'12b6251b-024d-42db-a87b-95043c0c18bb')::TEXT as "Enc.for how long days",
        get_coded_string_value(programEncounter.observations->'8e95a585-dc1c-4e1d-bf3e-3d759e62005a', concepts.map)::TEXT as "Enc.is there any blood in the stool",
        get_coded_string_value(programEncounter.observations->'47e11aab-6c94-401e-aaad-961d822cc862', concepts.map)::TEXT as "Enc.check the childs general condition,is the child lethargic or unconsious ?",
        get_coded_string_value(programEncounter.observations->'faa4ef73-b5ef-4b24-a261-ca3f15e40ed8', concepts.map)::TEXT as "Enc.restless or irritable",
        get_coded_string_value(programEncounter.observations->'407d008c-c3d2-44f6-a0bb-456e9629b05b', concepts.map)::TEXT as "Enc.look for sunken eyes",
        get_coded_string_value(programEncounter.observations->'b0de3dce-e5a1-45d1-a319-cc7eceecb6a4', concepts.map)::TEXT as "Enc.offer the child fluid , is the child unable to drink or drinking poorly",
        get_coded_string_value(programEncounter.observations->'bbc76bec-18ea-430e-a16d-d1121344ab25', concepts.map)::TEXT as "Enc.drinking eagerly",
        get_coded_string_value(programEncounter.observations->'a929909f-6bc2-4e0e-b1db-957123d67a23', concepts.map)::TEXT as "Enc.Is the child thirsty",
        get_coded_string_value(programEncounter.observations->'6e71b1e1-e5a1-49f5-9943-53ee837b4d8e', concepts.map)::TEXT as "Enc.Pinch the skin of the abdomen . Does it go back very slowly (Longer than 2 seconds )",
        get_coded_string_value(programEncounter.observations->'803fb63a-7121-4c9d-8060-c850eaeb866e', concepts.map)::TEXT as "Enc.does it go back slowly(less than 2 second)",
        get_coded_string_value(programEncounter.observations->'3059b1cf-b935-4d90-95bd-d6c5b4cf838e', concepts.map)::TEXT as "Enc.does child has history of fever",
        get_coded_string_value(programEncounter.observations->'71a59c4e-b468-4de8-be98-24eeb1031e01', concepts.map)::TEXT as "Enc.does child feels hot by touch",
        get_coded_string_value(programEncounter.observations->'cdf5f2b6-ec61-4dc3-8260-61960d1239ce', concepts.map)::TEXT as "Enc.Is temperature recorded?",
        (programEncounter.observations->>'22a24aab-b2f1-4fbd-9835-30b8d9843cf4')::TEXT as "Enc.what is the axillary temprature",
        get_coded_string_value(programEncounter.observations->'9a5019fa-cd87-441c-8b8c-f2373987178f', concepts.map)::TEXT as "Enc.Reason for not recording temperature",
        (programEncounter.observations->>'273dbfab-b4a8-4842-9272-2dc0e3aeaa93')::TEXT as "Enc.fever since how many days",
        get_coded_string_value(programEncounter.observations->'067b543f-27ba-4156-aa69-f9d268e5ab0f', concepts.map)::TEXT as "Enc.if fever since more than 7 days then look for stiff neck",
        get_coded_string_value(programEncounter.observations->'d96d63c9-36c7-4039-b5c6-aba9e83b539e', concepts.map)::TEXT as "Enc.does child has daily fever",
        get_coded_string_value(programEncounter.observations->'7f76de32-8a63-4dc0-bfc0-897ac15a4674', concepts.map)::TEXT as "Enc.does child have visible severe wasting",
        get_coded_string_value(programEncounter.observations->'c749befc-bc3e-4495-92db-5d2ffa5cd8c9', concepts.map)::TEXT as "Enc.Is there oedema on both feet",
        (programEncounter.observations->>'7d9af174-9e58-4e96-a77c-8351a5a4152d')::TEXT as "Enc.Height",
        (programEncounter.observations->>'bab98eac-14a5-43c4-80ff-ccdb8c3ddf1b')::TEXT as "Enc.Weight",
        (programEncounter.observations->>'68a6a336-4a91-468b-9b7d-ff37e637f5b7')::TEXT as "Enc.Current nutritional status according to weight and age",
        (programEncounter.observations->>'4f0378c2-834d-47d1-8000-06d9048828e9')::TEXT as "Enc.Current nutritional status according to weight and height",
        (programEncounter.observations->>'59e44308-2884-477a-96ef-701a4de23352')::TEXT as "Enc.MUAC of child",
        (programEncounter.observations->>'3fb85722-fd53-43db-9e8b-d34767af9f7e')::TEXT as "Enc.Nutritional status of child",
        get_coded_string_value(programEncounter.observations->'6df74fa2-036c-45c6-a6c2-de4c25d89695', concepts.map)::TEXT as "Enc.If child is in SAM then refered to CMTC?",
        (programEncounter.observations->>'827cc521-0a39-442b-b044-a6d9d87be708')::DATE as "Enc.refer date",
        get_coded_string_value(programEncounter.observations->'761eb3e1-df93-42f8-83a8-acb9b65cb834', concepts.map)::TEXT as "Enc.Look for palmer pallor",
        (programEncounter.observations->>'b540fc79-93cb-4f65-a802-a34281437a63')::TEXT as "Enc.If child is very weak or very anemic then check for his food",
        get_coded_string_value(programEncounter.observations->'da385e88-b879-482c-bdf2-1081a9ef1aed', concepts.map)::TEXT as "Enc.Whether child still get breastfeed",
        (programEncounter.observations->>'db32e8a8-14d7-4bab-9f66-83f898111944')::TEXT as "Enc.if yes then how many times in 24 hour",
        get_coded_string_value(programEncounter.observations->'2d7134a0-ad59-45a7-aa71-2adc43b0248c', concepts.map)::TEXT as "Enc.breast feed given in night also",
        get_coded_string_value(programEncounter.observations->'66bb9495-25de-4bc4-80ec-5d1a19a9b317', concepts.map)::TEXT as "Enc.does child recived any kind of liquid or solid food",
        (programEncounter.observations->>'7676a057-aac1-468d-800d-751ac01d7122')::TEXT as "Enc.how many times in 24 hours",
        get_coded_string_value(programEncounter.observations->'507bcc95-6f59-4814-85a2-fbd3ab623917', concepts.map)::TEXT as "Enc.how much food is given",
        get_coded_string_value(programEncounter.observations->'3d2ba75b-a3ba-4ff7-8dbd-86fa6d260155', concepts.map)::TEXT as "Enc.does child has any other complaint",
        (programEncounter.observations->>'f1606c37-7f5c-411f-8fb2-0c2313b103da')::TEXT as "Enc.write the complaint",
        get_coded_string_value(programEncounter.observations->'524de7d6-80e2-4821-b1c7-6e05c03da259', concepts.map)::TEXT as "Enc.Does child is going to anganwadi",
        get_coded_string_value(programEncounter.observations->'0575356d-d857-457a-ac16-3cdd1867ae2c', concepts.map)::TEXT as "Enc.recived food packets from anganwadi",
        get_coded_string_value(programEncounter.observations->'a10a0ab4-3a46-4709-92f5-43cdb81146c8', concepts.map)::TEXT as "Enc.does child went to VHND",
        get_coded_string_value(programEncounter.observations->'cb644b9e-d43a-4829-9f3e-9f4750ffbaa4', concepts.map)::TEXT as "Enc.does child require to refer",
        get_coded_string_value(programEncounter.observations->'ef729085-d135-4e6d-8072-3b2e6bf5b6e0', concepts.map)::TEXT as "Enc.Child Referred ?",
        get_coded_string_value(programEncounter.observations->'e6fdc0e0-e1bd-4a0f-8fd0-efc733418274', concepts.map)::TEXT as "Enc.who refered ?",
        get_coded_string_value(programEncounter.observations->'db23114a-899f-4904-b43f-0c8356960a25', concepts.map)::TEXT as "Enc.Place of referral",
        programEncounter.cancel_date_time "EncCancel.cancel_date_time",
        get_coded_string_value(programEncounter.observations->'0066a0f7-c087-40f4-ae44-a3e931967767', concepts.map)::TEXT as "EncCancel.Visit cancel reason",
        (programEncounter.observations->>'fadd881a-beed-47ea-a4d6-700009a61a32')::TEXT as "EncCancel.Other reason for cancelling",
        get_coded_string_value(programEncounter.observations->'dde645f5-0f70-45e9-a670-b7190c86c981', concepts.map)::TEXT as "EncCancel.Place of death",
        (programEncounter.observations->>'3b269f11-ed0a-4636-8273-da0259783214')::DATE as "EncCancel.Date of death",
        get_coded_string_value(programEncounter.observations->'7c88aea6-dfed-451e-a086-881e2dcfd85f', concepts.map)::TEXT as "EncCancel.Reason of death"

        FROM program_encounter programEncounter
         CROSS JOIN concepts
         LEFT OUTER JOIN operational_encounter_type oet on programEncounter.encounter_type_id = oet.encounter_type_id
         LEFT OUTER JOIN program_enrolment programEnrolment ON programEncounter.program_enrolment_id = programEnrolment.id
         LEFT OUTER JOIN operational_program op ON op.program_id = programEnrolment.program_id
         LEFT OUTER JOIN individual individual ON programEnrolment.individual_id = individual.id
         LEFT OUTER JOIN gender g ON g.id = individual.gender_id
         LEFT JOIN address_level village ON individual.address_id = village.id
         LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
         LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
         LEFT JOIN address_level block ON phc.parent_id = block.id


         WHERE op.uuid = '70e4db05-c79a-406c-89be-54f8d77f643a'
        AND (oet.uuid = '65fe2029-a5d8-455d-980e-c8a57576d8df' OR oet.uuid ='72a7e163-8950-4047-a2a1-737586867d53')
        AND programEncounter.encounter_date_time IS NOT NULL
        AND programEnrolment.enrolment_date_time IS NOT NULL);


drop view if exists jnpct_program_exit_view;
create view jnpct_program_exit_view as
    WITH concepts AS (
        SELECT hstore((array_agg(concept.uuid))::text[], (array_agg(concept.name))::text[]) AS map
        FROM concept
    )
    SELECT pe.enrolment_date_time,
           pe.program_exit_date_time,
           (i.date_of_birth)::timestamp without time zone                                AS date_of_birth,
           i.address_id,
           village.title                                                                 AS "Ind.village",
           i.id                                                                          as "Ind.Id",
           subcenter.title                                                               AS "Ind.subcenter",
           phc.title                                                                     AS "Ind.phc",
           block.title                                                                   AS "Ind.block",
           (get_coded_string_value((pe.program_exit_observations -> '29238876-fbd8-4f39-b749-edb66024e25e'::text),
                                   concepts.map))::text                                  AS reason_for_exit,
           ((pe.program_exit_observations ->>
             '3b269f11-ed0a-4636-8273-da0259783214'::text))::timestamp without time zone AS date_of_death,
           (get_coded_string_value((pe.program_exit_observations -> '7c88aea6-dfed-451e-a086-881e2dcfd85f'::text),
                                   concepts.map))::text                                  AS reason_of_death,
           (get_coded_string_value((pe.program_exit_observations -> 'dde645f5-0f70-45e9-a670-b7190c86c981'::text),
                                   concepts.map))::text                                  AS place_of_death
    FROM program_enrolment pe
        CROSS JOIN concepts
        LEFT JOIN operational_program op ON op.program_id = pe.program_id
        LEFT JOIN individual i ON pe.individual_id = i.id
        LEFT JOIN address_level village ON i.address_id = village.id
        LEFT JOIN address_level subcenter ON village.parent_id = subcenter.id
        LEFT JOIN address_level phc ON subcenter.parent_id = phc.id
        LEFT JOIN address_level block ON phc.parent_id = block.id
    WHERE (pe.program_exit_date_time IS NOT NULL);
