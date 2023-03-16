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
MiAbstractModel >> lastTagSelected [

	^lastTagSelected
	ifNil: [ FamixTag new name: 'noTag' ; color: Color transparent ; yourself ]
	ifNotNil: #yourself
]

{ #category : #accessing }
MiAbstractModel >> lastTagSelected: anObject [

	lastTagSelected := anObject
]

{ #category : #accessing }
MiAbstractModel >> settingsChanged: aBoolean [
	"by default don't do anything"
]

{ #category : #accessing }
MiAbstractModel >> tagList [

	self entities ifNil: [ ^#() ].
	self entities ifEmpty: [ ^#() ].
	^self entities anyOne mooseModel allTags
]

{ #category : #actions }
MiAbstractModel >> tagSelectedEntities [
	UIManager  default inform: 'tagging selected entities with: ' , self lastTagSelected name
]

{ #category : #accessing }
MiAbstractModel >> toolName [

	^ browser title
]
