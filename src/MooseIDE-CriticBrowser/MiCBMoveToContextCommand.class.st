Class {
	#name : #MiCBMoveToContextCommand,
	#superclass : #MiAbstractCriticBrowserCommand,
	#instVars : [
		'targetContext'
	],
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBMoveToContextCommand class >> defaultIconName [

	^ #glamorousRedo
]

{ #category : #default }
MiCBMoveToContextCommand class >> defaultName [

	^ 'Move to context:'
]

{ #category : #'instance creation' }
MiCBMoveToContextCommand class >> forSpecContext: aPresenter [

	| commandGroup |
	commandGroup := CmCommandGroup new asSpecGroup
		                name: 'Move to context: ';
		                iconName: #glamorousRedo.

	aPresenter allAvailableContexts do: [ :aCBContext | 
		commandGroup register:
			(self newForSpecContext: aPresenter targetContext: aCBContext) ].

	^ commandGroup
]

{ #category : #'instance creation' }
MiCBMoveToContextCommand class >> newForSpecContext: aPresenter targetContext: aTargetContext [

	^ (self new
		   context: aPresenter;
		   targetContext: aTargetContext) asSpecCommand
]

{ #category : #accessing }
MiCBMoveToContextCommand class >> priority [

	^ 7
]

{ #category : #converting }
MiCBMoveToContextCommand >> asSpecCommand [

	^ (self decorateWith: SpCommand)
		  iconName: #blank;
		  name: self targetContext name;
		  yourself
]

{ #category : #testing }
MiCBMoveToContextCommand >> canBeExecuted [

	^ self context rules isNotNil and: [ 
		  self context rules selectedItem class ~= FamixCBRootContext ]
]

{ #category : #executing }
MiCBMoveToContextCommand >> execute [

	self context moveCurrentRuleComponentToContext: self targetContext 
]

{ #category : #accessing }
MiCBMoveToContextCommand >> targetContext [

	^ targetContext
]

{ #category : #accessing }
MiCBMoveToContextCommand >> targetContext: anObject [

	targetContext := anObject
]
