Class {
	#name : #MiFreezeCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #'accessing - defaults' }
MiFreezeCommand class >> defaultName [

	^ 'Freeze'
]

{ #category : #accessing }
MiFreezeCommand >> iconName [

	^ self context canFollow
		  ifFalse: [ #radioButtonSelected ]
		  ifTrue: [ #radioButtonUnselected ]
]

{ #category : #accessing }
MiFreezeCommand >> receivingMode [

	^ MiFreezeMode
]
