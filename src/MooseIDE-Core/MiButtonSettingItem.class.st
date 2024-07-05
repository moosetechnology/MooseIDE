"
A MiSettingItem which value is given by a button that calls a ""secondary presenter""
"
Class {
	#name : #MiButtonSettingItem,
	#superclass : #MiAbstractSettingItem,
	#instVars : [
		'secondaryPresenter'
	],
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #initialization }
MiButtonSettingItem >> initialize [

	super initialize.

	presenter := SpButtonPresenter new.
	presenter label: 'Change'.

	presenter action: [
		| modal |
		self update.
		modal := secondaryPresenter asModalWindow.
		modal title: self label.
		modal open ].

	self initializeSecondaryPresenter
]

{ #category : #initialization }
MiButtonSettingItem >> initializeSecondaryPresenter [
	self subclassResponsibility
]

{ #category : #accessing }
MiButtonSettingItem >> owner: aPresenter [
	super owner: aPresenter.
	secondaryPresenter owner: aPresenter
]

{ #category : #initialization }
MiButtonSettingItem >> update [
	"empty in superclass but redefined in revelant subclasses."
]
