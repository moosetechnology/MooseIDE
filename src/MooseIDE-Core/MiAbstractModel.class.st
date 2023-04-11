"
An abstract model class for all MooseIDE browsers
IT knows its browser and have some default behavior implemented (e.g. to manage settings)
"
Class {
	#name : #MiAbstractModel,
	#superclass : #Object,
	#instVars : [
		'browser',
		'lastTagSelected'
	],
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #accessing }
MiAbstractModel >> browser [

	^ browser
]

{ #category : #accessing }
MiAbstractModel >> browser: anObject [

	browser := anObject
]

{ #category : #accessing }
MiAbstractModel >> currentApplication [

	^ browser application
]

{ #category : #accessing }
MiAbstractModel >> currentMooseModel [
	self entities ifNil: [ ^nil ].
	self entities ifEmpty: [ ^nil ].
	^self entities anyOne mooseModel
	
]

{ #category : #accessing }
MiAbstractModel >> entities [
	self subclassResponsibility 
]

{ #category : #initialization }
MiAbstractModel >> initializeSettings [

	^MiSettingsPresenter new
		ownerTool: self;
		yourself
]

{ #category : #accessing }
MiAbstractModel >> selectedTag [

	^self currentApplication tagSelectedInMooseModel: self currentMooseModel
]

{ #category : #accessing }
MiAbstractModel >> selectedTag: aTag [

	self currentApplication selectedTag: aTag
]

{ #category : #accessing }
MiAbstractModel >> settingsChanged: aBoolean [
	"by default don't do anything"
]

{ #category : #actions }
MiAbstractModel >> tagEntitiesSelected [
	UIManager  default inform: 'Unimplemented tagging (' , self selectedTag name, ') of selected entities'
]

{ #category : #accessing }
MiAbstractModel >> tagList [

	^self currentApplication tagListForMooseModel: self currentMooseModel 
]

{ #category : #accessing }
MiAbstractModel >> toolName [

	^ browser title
]
