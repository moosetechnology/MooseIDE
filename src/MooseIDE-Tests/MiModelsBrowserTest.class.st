Class {
	#name : #MiModelsBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'savedRoot'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiModelsBrowserTest >> browserClass [

	^ MiModelsBrowser
]

{ #category : #running }
MiModelsBrowserTest >> defaultEntityToSelect [

	^ super defaultEntityToSelect mooseModel
]

{ #category : #running }
MiModelsBrowserTest >> newModel: aString [

	| model |

	model := FamixStModel named: aString.
	MooseModel root add: model.

	^ model
]

{ #category : #running }
MiModelsBrowserTest >> receiveEntityToSelect [

	browser updateForNewModel: entityToSelect
]

{ #category : #running }
MiModelsBrowserTest >> setUp [

	savedRoot := MooseModelRoot installedRoot.
	MooseModelRoot resetRoot.
	super setUp
]

{ #category : #running }
MiModelsBrowserTest >> stModelFile [

	"Creating an in-memory JSON file containing a class from FamixStModel"

	| file |

	file := FileSystem workingDirectory / 'stModel.json'.

	file writeStreamDo: [ :stream |
		(FamixStModel new
			 newClassNamed: 'AClass';
			 yourself) exportToJSONStream: stream ].

	^ file
]

{ #category : #running }
MiModelsBrowserTest >> tearDown [

	MooseModelRoot installRoot: savedRoot.
	super tearDown
]

{ #category : #'tests - tags' }
MiModelsBrowserTest >> testCanTagEntities [

	self deny: browser canTagEntities
]

{ #category : #tests }
MiModelsBrowserTest >> testDisplayImportModelDialogTitle [

	| dialog |
	dialog := browser importFromFileUI.
	[self assert: dialog title equals: 'Import model from file']
		ensure: [ dialog delete].



	
]

{ #category : #tests }
MiModelsBrowserTest >> testFilterStubsSettingsWithStub [

	| newModel |
	self assert: browser miSelectedItemToPropagate isNil.

	newModel := self newModel: 'aModel'.
	(newModel newClassNamed: 'Class1') isStub: true.
	(newModel newClassNamed: 'Class2') isStub: false.

	self settingNamed: #shouldFilterStubs setValue: false.

	browser updateForNewModel: newModel.

	self assert: browser miSelectedItemToPropagate size equals: 2
]

{ #category : #tests }
MiModelsBrowserTest >> testFilterStubsSettingsWithoutStub [

	| newModel |

	self assert: browser miSelectedItemToPropagate isNil.

	newModel := self newModel: 'aModel'.
	(newModel newClassNamed: 'Class1') isStub: true.
	(newModel newClassNamed: 'Class2') isStub: false.

	browser updateForNewModel: newModel.

	self assert: browser miSelectedItemToPropagate size equals: 1.
	self
		assert: browser miSelectedItemToPropagate anyOne name
		equals: 'Class2'
]

{ #category : #tests }
MiModelsBrowserTest >> testHandleDropFileImportsModel [

	| file |
	file := self stModelFile.

	self assertEmpty: browser specModel entities.

	self settingNamed: #modelImportIsAutomatic setValue: true.
	browser handleDropFile: file.

	"Must wait a bit to ensure model finishes importing.
	 Also need to update list manually because only browsers in MiApplication are updated
	 and this one is in MiApplicationTest"
	[
		0.1 second wait.
		browser updateList ] ensure: [ file delete ].

	self assert: browser specModel entities size equals: 1
]

{ #category : #tests }
MiModelsBrowserTest >> testMiInspectCommand [

	| inspector result newModel |

	newModel := self newModel: 'aModel'.
	newModel newClass.
	browser updateForNewModel: newModel.

	inspector := Mock named: 'inspector'.
	(inspector stub inspect: Any forBuses: Any) will: [ :object :buses |
		result := object ].

	browser inspector: inspector.
	browser miInspect.

	self assert: result equals: newModel
]

{ #category : #tests }
MiModelsBrowserTest >> testMiInspectCommandWithoutStubFilter [

	| inspector result newModel |
	newModel := self newModel: 'aModel'.
	newModel newClass.

	browser updateForNewModel: newModel.

	self settingNamed: #shouldFilterStubs setValue: false.
	inspector := Mock named: 'inspector'.
	(inspector stub inspect: Any forBuses: Any) will: [ :object :buses |
		result := object ].

	browser inspector: inspector.
	browser miInspect.

	self assert: result equals: newModel
]

{ #category : #tests }
MiModelsBrowserTest >> testMiSelectedItem [

	| newModel |

	self assert: browser miSelectedItem isNil.

	newModel := self newModel: 'aModel'.
	browser updateForNewModel: newModel.

	self deny: browser miSelectedItem isNil
]

{ #category : #'tests - opening' }
MiModelsBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiModelsBrowserTest >> testUpdateForNewModel [

	| newModel |
	self newModel: 'model1'.
	browser updateList.

	self assert: browser specModel entities size equals: 1.
	self assert: browser specModel selected isNil.

	newModel := self newModel: 'model2'.
	browser updateForNewModel: newModel.

	self assert: browser specModel entities size equals: 2.
	self assert: browser specModel selected equals: newModel
]

{ #category : #tests }
MiModelsBrowserTest >> testUpdateForNewModelMultipleBrowsers [

	| browser2 newModel |
	browser2 := self browserClass openForTests: self application.
	self newModel: 'model1'.

	browser updateList.

	self assert: browser specModel entities size equals: 1.
	self assert: browser specModel selected isNil.

	self assert: browser2 specModel entities size equals: 1.
	self assert: browser2 specModel selected isNil.

	newModel := self newModel: 'model2'.
	browser updateForNewModel: newModel.

	self assert: browser specModel entities size equals: 2.
	self assert: browser specModel selected equals: newModel.

	self assert: browser2 specModel entities size equals: 2.
	self assert: browser2 specModel selected isNil.

	browser2 window close
]

{ #category : #tests }
MiModelsBrowserTest >> testUpdateList [

	self assertEmpty: browser specModel entities.

	self newModel: 'aModel'.
	browser updateList.

	self assert: browser specModel entities size equals: 1
]

{ #category : #tests }
MiModelsBrowserTest >> testWithCacheSettingNoCache [
	"Importing by default is without cache"

	| newModel |
	newModel := self newModel: 'aModel'.
	(newModel newClassNamed: 'Class1').
	(newModel newClassNamed: 'Class2').

	browser importFromFileUI importModelStep2Install: newModel.

	self assert: (newModel cacheAt: FamixTClass ifAbsent: [ true ] ifPresent: [:cache | cache isEmpty ])
]

{ #category : #tests }
MiModelsBrowserTest >> testWithCacheSettingWithCache [

	| newModel |
	newModel := self newModel: 'aModel'.
	newModel newClassNamed: 'Class1'.
	newModel newClassNamed: 'Class2'.

	self settingNamed: #shouldCreateCache setValue: true.
	browser importFromFileUI importModelStep2Install: newModel.

	self assert: (newModel
			 cacheAt: FamixTClass
			 ifAbsent: [ false ]
			 ifPresent: [ :cache | cache isEmpty not ])
]
