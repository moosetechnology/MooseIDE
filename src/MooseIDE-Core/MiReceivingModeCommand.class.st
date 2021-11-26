Class {
	#name : #MiReceivingModeCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #converting }
MiReceivingModeCommand class >> asCommandGroupForSpecContext: aBrowser [

	| group |
	group := CmCommandGroup forSpec name: 'Receiving Mode'.
	self subclassesDo: [ :cmd | 
		group register: (cmd forSpecContext: aBrowser) ].
	^ group
]

{ #category : #converting }
MiReceivingModeCommand >> asSpecCommand [

	^ super asSpecCommand
		  iconName: self iconName;
		  yourself
]

{ #category : #executing }
MiReceivingModeCommand >> execute [

	self context receivingMode: self receivingMode.
	self context window updateReceivingModeButtons
]

{ #category : #accessing }
MiReceivingModeCommand >> iconName [

	^ self subclassResponsibility
]

{ #category : #accessing }
MiReceivingModeCommand >> iconNameForState: aBoolean [

	^ aBoolean
		  ifTrue: [ #radioButtonSelected ]
		  ifFalse: [ #radioButtonUnselected ]
]

{ #category : #accessing }
MiReceivingModeCommand >> receivingMode [

	^ self subclassResponsibility
]
