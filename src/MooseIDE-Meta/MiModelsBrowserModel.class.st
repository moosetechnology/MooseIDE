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
	#instVars : [
		'mooseModelsList',
		'selected',
		'settings'
	],
	#category : #'MooseIDE-Meta-ModelsBrowser'
}

{ #category : #updating }
MiModelsBrowserModel >> allModelRootBrowser [

	^ browser application allBrowsers: MiModelsBrowser
]

{ #category : #settings }
MiModelsBrowserModel >> autoImportSetting [

	^ settings getItemValue: #modelAutoImportSetting
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
	mooseModelsList := self availableMooseModels.

	self initializeSettings 
]

{ #category : #initialization }
MiModelsBrowserModel >> initializeSettings [ 

	settings := super initializeSettings.
	settings	addItem: (MiCheckboxSettingItem new
		setValue: true ;
		label: 'Filter out stubs?' ;
		help: 'When propagating the model should it filter out the stub entities or pass them along' ;
		yourself)
		named: #filterStubsSetting.
		
	settings addItem: (MiCheckboxSettingItem new
		setValue: false ;
		label: 'Automatically import drag&drop files?' ;
		help: 'When drag & drop model from file should it be automatically imported if possible or should it just configure the import dialog' ;
		yourself)
		named: #modelAutoImportSetting.
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

	^ self shouldFilterStubs
		  ifTrue: [ self selected ifNotNil: [ :selectedModel | (selectedModel reject: [ :each | each isStub ]) asMooseGroup ] ]
		  ifFalse: [ self selected ]
]

{ #category : #'accessing - tests' }
MiModelsBrowserModel >> settings [
	^ settings
]

{ #category : #accessing }
MiModelsBrowserModel >> shouldFilterStubs [

	^ settings getItemValue: #filterStubsSetting
]

{ #category : #updating }
MiModelsBrowserModel >> updateForNewModel: aMooseModel [

	self allModelRootBrowser do: [ :modelBrowser |
		modelBrowser updateList ].
	self selected: aMooseModel
]

{ #category : #updating }
MiModelsBrowserModel >> updateMooseModelsList [

	mooseModelsList := self availableMooseModels.
	browser listOfMooseModels: mooseModelsList
]
