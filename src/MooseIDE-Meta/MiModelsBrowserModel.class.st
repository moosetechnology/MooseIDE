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
	#name : #MiModelsBrowserModel,
	#superclass : #MiAbstractModel,
	#traits : 'MiTSpecModelWithSettings',
	#classTraits : 'MiTSpecModelWithSettings classTrait',
	#instVars : [
		'mooseModelsList',
		'selected',
		'shouldFilterStubs',
		'shouldCreateCache',
		'modelImportIsAutomatic'
	],
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #settings }
MiModelsBrowserModel class >> defaultFilterStubs [

	^ true
]

{ #category : #settings }
MiModelsBrowserModel class >> defaultModelImportIsAutomatic [

	^ false
]

{ #category : #settings }
MiModelsBrowserModel class >> defaultShouldCreateCache [

	^ false
]

{ #category : #settings }
MiModelsBrowserModel class >> mementoForDefaultValues [

	^ MiModelsSettingsMemento new
		  shouldCreateCache: self defaultShouldCreateCache;
		  filterStubs: self defaultFilterStubs;
		  modelImportIsAutomatic: self defaultModelImportIsAutomatic;
		  yourself
]

{ #category : #commands }
MiModelsBrowserModel class >> settingsCommandsOn: aMemento [

	^ OrderedCollection new
		  add: (MiCreateCacheSettingCommand forContext: aMemento);
		  add: (MiFilterStubsSettingCommand forContext: aMemento);
		  add: (MiAutomaticModelsImportSettingCommand forContext: aMemento);
		  yourself
]

{ #category : #updating }
MiModelsBrowserModel >> allModelRootBrowser [

	^ browser application allBrowsers: MiModelsBrowser
]

{ #category : #accessing }
MiModelsBrowserModel >> availableMooseModels [

	^ MooseModel root entities
]

{ #category : #accessing }
MiModelsBrowserModel >> currentMooseModel [

	^ self selected
]

{ #category : #'accessing - tests' }
MiModelsBrowserModel >> entities [

	^ mooseModelsList
]

{ #category : #'accessing - tests' }
MiModelsBrowserModel >> entities: aList [

	mooseModelsList := aList
]

{ #category : #initialization }
MiModelsBrowserModel >> initialize [

	super initialize.
	mooseModelsList := self availableMooseModels
]

{ #category : #initialization }
MiModelsBrowserModel >> initializeSettings [

	shouldCreateCache := self class defaultShouldCreateCache.
	shouldFilterStubs := self class defaultFilterStubs.
	modelImportIsAutomatic := self class defaultModelImportIsAutomatic
]

{ #category : #settings }
MiModelsBrowserModel >> modelImportIsAutomatic [

	^ modelImportIsAutomatic
]

{ #category : #'settings management' }
MiModelsBrowserModel >> newMemento [

	^ MiModelsSettingsMemento new
		  shouldCreateCache: shouldCreateCache;
		  filterStubs: shouldFilterStubs;
		  modelImportIsAutomatic: modelImportIsAutomatic;
		  yourself
]

{ #category : #accessing }
MiModelsBrowserModel >> selected [

	^ selected
]

{ #category : #accessing }
MiModelsBrowserModel >> selected: anObject [
	selected := anObject.
	browser updateToolbar
]

{ #category : #accessing }
MiModelsBrowserModel >> selectedModel [

	^ shouldFilterStubs
		  ifTrue: [
				  self selected ifNotNil: [ :selectedModel |
					  (selectedModel reject: [ :each | each isStub ]) asMooseGroup ] ]
		  ifFalse: [ self selected ]
]

{ #category : #settings }
MiModelsBrowserModel >> shouldCreateCache [

	^ shouldCreateCache
]

{ #category : #updating }
MiModelsBrowserModel >> updateForNewModel: aMooseModel [

	self allModelRootBrowser do: [ :modelBrowser |
		modelBrowser updateList ].
	self selected: aMooseModel
]

{ #category : #'settings management' }
MiModelsBrowserModel >> updateFromMemento: aMemento [

	shouldCreateCache := aMemento shouldCreateCache.
	shouldFilterStubs := aMemento filterStubs.
	modelImportIsAutomatic := aMemento modelImportIsAutomatic
]

{ #category : #updating }
MiModelsBrowserModel >> updateMooseModelsList [

	mooseModelsList := self availableMooseModels.
	browser listOfMooseModels: mooseModelsList
]
