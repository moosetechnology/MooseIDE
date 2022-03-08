"
I work as an area that accepts drops.
I will install the drop into a presenter (my #dropInto:)
I cannot be shown by my self, but i can be embedded into different containers. 

"
Class {
	#name : #MiDragHerePresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'dropInto'
	],
	#category : #'MooseIDE-Core-workspace'
}

{ #category : #specs }
MiDragHerePresenter class >> adapterName [ 
	 ^ #SpMorphicDragHereAdapter
]

{ #category : #'changing suspended state' }
MiDragHerePresenter >> dropInto: aDropIn [
	"the widget that will accept the drop"
	dropInto := aDropIn
]

{ #category : #initialization }
MiDragHerePresenter >> initialize [
	super initialize.
	self dropEnabled: true.
]

{ #category : #'changing suspended state' }
MiDragHerePresenter >> install: aPresenter [
	^ dropInto install: aPresenter
]

{ #category : #testing }
MiDragHerePresenter >> noteThatWidgetHasBeenClosed: anAlceSourceCodeWidget [
	self flag: 'to remove ?'.
	dropInto noteThatWidgetHasBeenClosed: anAlceSourceCodeWidget
]
