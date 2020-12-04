CREATE TABLE [dbo].[Conversation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](max) NOT NULL,
	[added] [datetime] NOT NULL,
	[idConversationUser] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Conversation] ADD  CONSTRAINT [DF_Conversation_added]  DEFAULT (getdate()) FOR [added]
GO


