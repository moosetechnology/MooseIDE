"
A tool to manage tags

Allows to create new tag, give them name, put them in a hierarchy of tags, give them a color, and of course add or remove entities carrying a tag

"
Class {
	#name : #MiTagBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'tagModel',
		'tagManagementPage',
		'tagIntentPage',
		'tagExtentPage',
		'tagIsIntent',
		'tagCreationForm'
	],
	#category : #'MooseIDE-Tagging-Browser'
}

{ #category : #specs }
MiTagBrowser class >> defaultSpec [
	^super defaultSpec
		add: #mainPresenter;
		yourself
]

{ #category : #'world menu' }
MiTagBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #FilesBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
]

{ #category : #'instance creation' }
MiTagBrowser class >> mostRecentModel [
	^ self currentApplication defaultBus logger mostRecentEntity
		ifNotNil: [ :entity | entity mooseModel ]
		ifNil: [ MooseModel new ]
]

{ #category : #'instance creation' }
MiTagBrowser class >> newModel [

	^ MiTagBrowserModel new
]

{ #category : #'instance creation' }
MiTagBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiTagBrowser class >> title [
	^ 'Tag browser'
]

{ #category : #specs }
MiTagBrowser class >> windowSize [

	^ 700 @ 475
]

{ #category : #testing }
MiTagBrowser >> canFollowEntity: anObject [
	^ anObject isCollection
		and: [ anObject
				anySatisfy: [ :a | a usesFamixTrait: FamixTNamedEntity ] ]
]

{ #category : #initialization }
MiTagBrowser >> closeTagCreationForm [

	self layout replace: tagCreationForm with: tagManagementPage
]

{ #category : #testing }
MiTagBrowser >> createTag: name description: aText color: aColor [

	| newTag |
	newTag := self tagModel addTag: name.
	(aText notNil and: [ aText isNotEmpty ]) ifTrue: [ 
		newTag description: aText ].
	aColor notNil ifTrue: [ newTag color: aColor ].
	tagManagementPage refreshTagList
]

{ #category : #actions }
MiTagBrowser >> followEntity: anEntity [

	tagModel entities: anEntity.
	tagManagementPage refresh
]

{ #category : #initialization }
MiTagBrowser >> initialize [
	super initialize.
	tagIsIntent := true
]

{ #category : #initialization }
MiTagBrowser >> initializeLayout [

	self layout: (SpBoxLayout newLeftToRight
			 add: tagManagementPage;
			 yourself)
]

{ #category : #initialization }
MiTagBrowser >> initializePresenters [

	tagCreationForm := MiTagCreationForm owner: self.
	tagManagementPage := MiTagManagementPage owner: self.
	self initializeLayout
]

{ #category : #accessing }
MiTagBrowser >> miSelectedItem [

	^ tagModel entities
]

{ #category : #initialization }
MiTagBrowser >> openTagCreationForm [

	tagCreationForm reset.
	self layout replace: tagManagementPage with: tagCreationForm
]

{ #category : #'accessing - model' }
MiTagBrowser >> setModelBeforeInitialization: aTagModel [

	tagModel := aTagModel.
	tagModel tagBrowser: self
]

{ #category : #initialization }
MiTagBrowser >> setTagTo: aTag [

	self tagModel currentTag: aTag
]

{ #category : #testing }
MiTagBrowser >> tagModel [

	^ tagModel
]
