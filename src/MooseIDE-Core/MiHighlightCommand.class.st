"
I represent a command corresponding to a highlight button in browsers.
This command allows to highlight changes that have been pushed by the bus last.
"
Class {
	#name : #MiHighlightCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiHighlightCommand class >> defaultDescription [
	^ 'A mode that allows to highlight in current visualization/state changes just pushed on the bus'
]

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
