CREATE PROCEDURE [dbo].[_CQ_ListConversations]
(
	@room AS VARCHAR(250)
)
AS
BEGIN
	SELECT '"' + CONVERT(VARCHAR,a.id) + '_~_' + a.[name] + '"' AS Result
		FROM [Conversation] a
			INNER JOIN ConversationUser b ON b.[id] = a.idConversationUser
		WHERE b.[name] = @room
		ORDER BY a.[added] DESC, a.[name]
END
GO


