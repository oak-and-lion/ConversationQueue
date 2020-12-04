CREATE TABLE [dbo].[ConversationParticipant](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](max) NOT NULL,
	[idConversation] [int] NOT NULL,
	[notes] [varchar](250) NULL,
	[added] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ConversationParticipant] ADD  CONSTRAINT [DF_ConversationParticipant_added]  DEFAULT (getdate()) FOR [added]
GO


