ALTER PROCEDURE [dbo].[_CQ_DeleteConversation]
	@id AS INT
AS
BEGIN
	DELETE FROM ConversationParticipant
		WHERE idConversation = @id
	DELETE FROM [Conversation]
		WHERE id = @id
	SELECT 1 AS Result
END