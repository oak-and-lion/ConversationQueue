ALTER PROCEDURE [dbo].[_CQ_Addconversation]
	@name VARCHAR(MAX),
	@idUser VARCHAR(36)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM ConversationUser WHERE id = @idUser)
	BEGIN
		SELECT 3 AS Result
	END
	ELSE
	BEGIN
		DECLARE @total INT
		SELECT @total = COUNT(1) FROM [Conversation] WHERE idConversationUser = @idUser
		IF (@total < 6)
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM [Conversation] WHERE [name] = @name AND idConversationUser = @idUser)
			BEGIN
				DECLARE @userName VARCHAR(250)
				SELECT @userName = [name] FROM ConversationUser
					WHERE id = @idUser

				INSERT INTO [Conversation]
					([name], idConversationUser)
				VALUES
					(@name, @idUser)

				SELECT 1 AS Result
			END
			ELSE
			BEGIN
				SELECT 2 AS Result
			END
		END
		ELSE
		BEGIN
			SELECT 4 AS Result
		END
	END
END
