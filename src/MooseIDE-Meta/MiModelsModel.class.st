"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	model:		<Object>
	selected:		<Object>


    Implementation Points
"
Class {
	#name : 'MiModelsModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'mooseModelsList',
		'selected',
		'shouldFilterStubs',
		'shouldCreateCache',
		'modelImportIsAutomatic'
	],
	#category : 'MooseIDE-Meta-ModelsBrowser',
	#package : 'MooseIDE-Meta',
	#tag : 'ModelsBrowser'
}

{ #category : 'settings management' }
MiModelsModel class >> defaultConfiguration [

	^ MiModelsSettingsConfiguration new
		  shouldCreateCache: self defaultShouldCreateCache;
		  filterStubs: self defaultFilterStubs;
		  modelImportIsAutomatic: self defaultModelImportIsAutomatic;
		  yourself
]

{ #category : 'settings management' }
MiModelsModel class >> defaultFilterStubs [

	^ true
]

{ #category : 'settings management' }
MiModelsModel class >> defaultModelImportIsAutomatic [

	^ false
]

{ #category : 'settings management' }
MiModelsModel class >> defaultShouldCreateCache [

	^ false
]

{ #category : 'updating' }
MiModelsModel >> allModelRootBrowser [

	^ browser application allBrowsers: MiModelsBrowser
]

{ #category : 'accessing' }
MiModelsModel >> availableMooseModels [

	^ MooseModel root entities
]

{ #category : 'settings management' }
MiModelsModel >> currentConfiguration [

	^ MiModelsSettingsConfiguration new
		  shouldCreateCache: shouldCreateCache;
		  filterStubs: shouldFilterStubs;
		  modelImportIsAutomatic: modelImportIsAutomatic;
		  yourself
]

{ #category : 'accessing' }
MiModelsModel >> currentMooseModel [

	^ self selected
]

{ #category : 'settings management' }
MiModelsModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing - tests' }
MiModelsModel >> entities [

	^ mooseModelsList
]

{ #category : 'accessing - tests' }
MiModelsModel >> entities: aList [

	mooseModelsList := aList
]

{ #category : 'testing' }
MiModelsModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiModelsModel >> initialize [

	super initialize.
	mooseModelsList := self availableMooseModels
]

{ #category : 'initialization' }
MiModelsModel >> initializeSettings [

	shouldCreateCache := self class defaultShouldCreateCache.
	shouldFilterStubs := self class defaultFilterStubs.
	modelImportIsAutomatic := self class defaultModelImportIsAutomatic
]

{ #category : 'settings' }
MiModelsModel >> modelImportIsAutomatic [

	^ modelImportIsAutomatic
]

{ #category : 'accessing' }
MiModelsModel >> selected [

	^ selected
]

{ #category : 'accessing' }
MiModelsModel >> selected: anObject [
	selected := anObject.
	browser updateToolbar
]

{ #category : 'accessing' }
MiModelsModel >> selectedModel [

	^ shouldFilterStubs
		  ifTrue: [
				  self selected ifNotNil: [ :selectedModel |
					  (selectedModel reject: [ :each | each isStub ]) asMooseGroup ] ]
		  ifFalse: [ self selected ]
]

{ #category : 'settings management' }
MiModelsModel >> settingsPresenterExtent [
	"Large extent because checkboxes are large"

	^ 475 @ 250
]

{ #category : 'settings' }
MiModelsModel >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : 'settings management' }
MiModelsModel >> updateFromConfiguration: aConfiguration [

	shouldCreateCache := aConfiguration shouldCreateCache.
	shouldFilterStubs := aConfiguration filterStubs.
	modelImportIsAutomatic := aConfiguration modelImportIsAutomatic
]

{ #category : 'updating' }
MiModelsModel >> updateMooseModelsList [

	mooseModelsList := self availableMooseModels.
	browser listOfMooseModels: mooseModelsList
]
