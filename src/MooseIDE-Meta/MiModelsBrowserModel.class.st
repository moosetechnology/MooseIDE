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
	#name : 'MiModelsBrowserModel',
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
MiModelsBrowserModel class >> defaultConfiguration [

	^ MiModelsSettingsMemento new
		  shouldCreateCache: self defaultShouldCreateCache;
		  filterStubs: self defaultFilterStubs;
		  modelImportIsAutomatic: self defaultModelImportIsAutomatic;
		  yourself
]

{ #category : 'settings management' }
MiModelsBrowserModel class >> defaultFilterStubs [

	^ true
]

{ #category : 'settings management' }
MiModelsBrowserModel class >> defaultModelImportIsAutomatic [

	^ false
]

{ #category : 'settings management' }
MiModelsBrowserModel class >> defaultShouldCreateCache [

	^ false
]

{ #category : 'updating' }
MiModelsBrowserModel >> allModelRootBrowser [

	^ browser application allBrowsers: MiModelsBrowser
]

{ #category : 'accessing' }
MiModelsBrowserModel >> availableMooseModels [

	^ MooseModel root entities
]

{ #category : 'settings management' }
MiModelsBrowserModel >> currentConfiguration [

	^ MiModelsSettingsMemento new
		  shouldCreateCache: shouldCreateCache;
		  filterStubs: shouldFilterStubs;
		  modelImportIsAutomatic: modelImportIsAutomatic;
		  yourself
]

{ #category : 'accessing' }
MiModelsBrowserModel >> currentMooseModel [

	^ self selected
]

{ #category : 'settings management' }
MiModelsBrowserModel >> defaultConfiguration [

	^ self class defaultConfiguration
]

{ #category : 'accessing - tests' }
MiModelsBrowserModel >> entities [

	^ mooseModelsList
]

{ #category : 'accessing - tests' }
MiModelsBrowserModel >> entities: aList [

	mooseModelsList := aList
]

{ #category : 'testing' }
MiModelsBrowserModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiModelsBrowserModel >> initialize [

	super initialize.
	mooseModelsList := self availableMooseModels
]

{ #category : 'initialization' }
MiModelsBrowserModel >> initializeSettings [

	shouldCreateCache := self class defaultShouldCreateCache.
	shouldFilterStubs := self class defaultFilterStubs.
	modelImportIsAutomatic := self class defaultModelImportIsAutomatic
]

{ #category : 'settings' }
MiModelsBrowserModel >> modelImportIsAutomatic [

	^ modelImportIsAutomatic
]

{ #category : 'accessing' }
MiModelsBrowserModel >> selected [

	^ selected
]

{ #category : 'accessing' }
MiModelsBrowserModel >> selected: anObject [
	selected := anObject.
	browser updateToolbar
]

{ #category : 'accessing' }
MiModelsBrowserModel >> selectedModel [

	^ shouldFilterStubs
		  ifTrue: [
				  self selected ifNotNil: [ :selectedModel |
					  (selectedModel reject: [ :each | each isStub ]) asMooseGroup ] ]
		  ifFalse: [ self selected ]
]

{ #category : 'settings management' }
MiModelsBrowserModel >> settingsPresenterExtent [
	"Large extent because checkboxes are large"

	^ 475 @ 250
]

{ #category : 'settings' }
MiModelsBrowserModel >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : 'updating' }
MiModelsBrowserModel >> updateForNewModel: aMooseModel [

	self allModelRootBrowser do: [ :modelBrowser |
		modelBrowser updateList ].
	self selected: aMooseModel
]

{ #category : 'settings management' }
MiModelsBrowserModel >> updateFromConfiguration: aConfiguration [

	shouldCreateCache := aConfiguration shouldCreateCache.
	shouldFilterStubs := aConfiguration filterStubs.
	modelImportIsAutomatic := aConfiguration modelImportIsAutomatic
]

{ #category : 'updating' }
MiModelsBrowserModel >> updateMooseModelsList [

	mooseModelsList := self availableMooseModels.
	browser listOfMooseModels: mooseModelsList
]
