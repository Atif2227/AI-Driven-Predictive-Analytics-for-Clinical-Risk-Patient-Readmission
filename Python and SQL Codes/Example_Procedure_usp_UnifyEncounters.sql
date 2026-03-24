CREATE PROCEDURE [dbo].[usp_UnifyEncounters]
    @HospitalSiteID NVARCHAR(50),
    @RawTableName NVARCHAR(100)
AS
BEGIN
    -- This logic "stacks" the new data into the master table
    INSERT INTO [Silver].[Fact_Encounters] (
        [EncounterID],
        [PatientID],
        [AdmissionDate],
        [Site_ID],
        [IngestionTimestamp]
    )
    SELECT 
        [Raw_ID],          -- Mapping different source names
        [Pat_Num],         -- to a single standard
        TRY_CAST([Admit_DT] AS DATETIME), -- Standardizing formats
        @HospitalSiteID,   -- Adding the "City Tag"
        GETDATE()          -- Audit trail
    FROM @RawTableName;
END
