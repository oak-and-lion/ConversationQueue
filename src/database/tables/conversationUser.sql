CREATE TABLE [dbo].[ConversationUser](
	[id] [uniqueidentifier] NOT NULL,
	[name] [varchar](250) NOT NULL,
	[pwd] [varchar](250) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ConversationUser] ADD  CONSTRAINT [DF_ConversationUser_id]  DEFAULT (newid()) FOR [id]
GO


