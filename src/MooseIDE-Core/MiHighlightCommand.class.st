Class {
	#name : #MiHighlightCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiHighlightCommand class >> defaultName [

	^ 'Highlight'
]

{ #category : #testing }
MiHighlightCommand >> canBeExecuted [
	^ self context canHighlight
]

{ #category : #accessing }
MiHighlightCommand >> iconName [

	^ self iconNameForState: false
]

{ #category : #accessing }
MiHighlightCommand >> receivingMode [

	^ MiHighlightMode
]
