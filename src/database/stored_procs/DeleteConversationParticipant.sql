ALTER PROCEDURE [dbo].[_CQ_DeleteConversationParticipant]
	@id AS INT
AS
BEGIN
	DELETE FROM ConversationParticipant
		WHERE id = @id
	SELECT 1 AS Result
END