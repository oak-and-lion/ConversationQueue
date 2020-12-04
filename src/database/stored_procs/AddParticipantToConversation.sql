CREATE PROCEDURE [dbo].[_CQ_AddParticipantToConversation] 
(
	@idConversation AS INT,
	@name AS VARCHAR(MAX),
	@notes AS VARCHAR(250)
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [Conversation] WHERE id = @idConversation)
	BEGIN
		INSERT INTO ConversationParticipant
			(idConversation, [name], [notes])
		VALUES
			(@idConversation, @name, @notes)

		SELECT 1 AS Result
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END