Class {
	#name : #MiWindowPresenter,
	#superclass : #SpWindowPresenter,
	#instVars : [
		'toolbarCommandGroup'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #commands }
MiWindowPresenter class >> actionsCommandGroupFor: aPresenter [

	^ CmCommandGroup forSpec
		  name: 'Actions';
		  register:
			  (MiPropagateCommand forSpecContext: aPresenter)
				  beDisplayedOnRightSide;
		  register:
			  (MiInspectCommand forSpecContext: aPresenter)
				  beDisplayedOnRightSide
]

{ #category : #commands }
MiWindowPresenter class >> buildCommandsGroupWith: aPresenter forRoot: rootCommandGroup [

	rootCommandGroup
		register:
			(MiReceivingModeCommand asCommandGroupForSpecContext: aPresenter);
		register: (MiEditBusCommand forSpecContext: aPresenter);
		register:
			(MiHelpCommand forSpecContext: aPresenter) beDisplayedOnRightSide;
		register: (self actionsCommandGroupFor: aPresenter)
]

{ #category : #commands }
MiWindowPresenter class >> buildExtensionCommandsWith: aPresenter forRoot: rootCommandGroup [

	aPresenter canTagEntities ifTrue: [
		rootCommandGroup register: (self taggingCommandGroupFor: aPresenter) ].

	aPresenter hasSettings ifTrue: [
		rootCommandGroup register:
			(MiSettingsCommand forSpecContext: aPresenter)
				beDisplayedOnRightSide ].

	aPresenter hasVisualization ifTrue: [
		rootCommandGroup register:
			(MiExportVisualizationCommand forSpecContext: aPresenter)
				beDisplayedOnRightSide ]
]

{ #category : #commands }
MiWindowPresenter class >> taggingCommandGroupFor: aPresenter [

	^ CmCommandGroup forSpec
		  name: 'Tagging';
		  register: (MiTagCommand forSpecContext: aPresenter);
		  register: (MiSelectTagCommand forSpecContext: aPresenter)
]

{ #category : #toolbar }
MiWindowPresenter >> buildToolbar [

	self toolbar: (self newToolbar
			 fillWith: self toolbarCommandGroup;
			 yourself)
]

{ #category : #toolbar }
MiWindowPresenter >> defaultCommandsContext [

	^ presenter
]

{ #category : #private }
MiWindowPresenter >> defaultInitialExtent [

	^ 500 @ 400
]

{ #category : #initialization }
MiWindowPresenter >> setContextBindingKeys [

	self contextKeyBindings:
		(self class actionsCommandGroupFor: presenter) asKMCategory
]

{ #category : #toolbar }
MiWindowPresenter >> toolbarCommandGroup [

	^ toolbarCommandGroup ifNil: [ 
		  toolbarCommandGroup := self rootCommandsGroup ]
]

{ #category : #toolbar }
MiWindowPresenter >> updateBusButton [

	| busEditCommand |
	busEditCommand := self toolbarCommandGroup
		                  commandOrGroupNamed: 'Buses'
		                  ifNone: [ ^ self ].
	busEditCommand presenter ifNil: [ ^ self ].
	busEditCommand presenter
		label: busEditCommand dynamicName;
		help: busEditCommand dynamicDescription.
	busEditCommand updateEnableStatus
]

{ #category : #toolbar }
MiWindowPresenter >> updateReceivingModeButtons [

	(self toolbarCommandGroup commandOrGroupNamed: 'Receiving Mode')
		commands do: [ :cmd | 
		cmd updateIconForMode: presenter receivingMode ]
]

{ #category : #toolbar }
MiWindowPresenter >> updateReceivingModelToolbarButtons [

	(self toolbarCommandGroup
		 commandOrGroupNamed: 'Receiving Mode'
		 ifNone: [ ^ self ]) commands do: [ :cmd |
		cmd canBeExecuted ifFalse: [
			cmd presenter icon: (cmd icon lighter: 0.4) ] ]
]

{ #category : #toolbar }
MiWindowPresenter >> updateTaggingToolbarButton [

	| tagCommand |
	tagCommand := (self toolbarCommandGroup
		               commandOrGroupNamed: 'Tagging'
		               ifNone: [ ^ self ])
		              commandOrGroupNamed: MiTagCommand defaultName
		              ifNone: [ ^ self ].

	tagCommand canBeExecuted ifTrue: [
		tagCommand presenter label: self presenter selectedTag name ].
	tagCommand presenter icon:
		(self application iconForTag: self presenter selectedTag)
]

{ #category : #toolbar }
MiWindowPresenter >> updateToolbar [

	self toolbarCommandGroup allCommands do: [ :cmd |
		cmd updateEnableStatus ].

	self updateReceivingModelToolbarButtons.

	self updateTaggingToolbarButton
]
