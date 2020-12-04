CREATE PROCEDURE [dbo].[_CQ_ListConversationParticipants]
	@id AS INT
AS
BEGIN
	SELECT '"' + CONVERT(VARCHAR,id) + '_~_' + [name] + '_~_'  + [notes] + '_~_' + CONVERT(VARCHAR, @id) + '"'  AS Result
		FROM [ConversationParticipant]
		WHERE idConversation = @id
		ORDER BY [added],[name]
END
GO


