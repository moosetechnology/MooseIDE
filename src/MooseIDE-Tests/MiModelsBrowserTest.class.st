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
MiModelsBrowserTest >> newModel: aString [

	| model |

	model := FamixStModel named: aString.
	MooseModel root add: model.

	^ model
]

{ #category : #tests }
MiModelsBrowserTest >> setEntityToSelect [ 
	| newModel |
	newModel := self newModel: 'aModel'.
	newModel newClassNamed: #AClass.
	
	browser updateForNewModel: newModel.

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
		equals: 'Class2'.

	browser settingsItem setItem: #filterStubsSetting value: false.
	browser updateForNewModel: newModel.
	self assert: browser miSelectedItemToPropagate size equals: 2
]

{ #category : #tests }
MiModelsBrowserTest >> testHandleDropFileImportsModel [

	| file |

	file := self stModelFile.

	self assertEmpty: browser model entities.

	browser settingsItem setItem: #modelAutoImportSetting value: true.
	browser handleDropFile: file.

	"Must wait a bit to ensure model finishes importing.
	 Also need to update list manually because only browsers in MiApplication are updated
	 and this one is in MiApplicationTest"
	[
	0.1 second wait.
	browser updateList ] ensure: [ file delete ].

	self assert: browser model entities size equals: 1
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

	browser settingsItem setItem: #filterStubsSetting value: false.
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

{ #category : #tests }
MiModelsBrowserTest >> testMiSelectedItemWithoutStub [

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

{ #category : #'tests - opening' }
MiModelsBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiModelsBrowserTest >> testUpdateForNewModel [

	| newModel |

	self newModel: 'model1'.
	browser updateList.

	self assert: browser model entities size equals: 1.
	self assert: browser model selected isNil.

	newModel := self newModel: 'model2'.
	browser updateForNewModel: newModel.

	self assert: browser model entities size equals: 2.
	self assert: browser model selected equals: newModel
]

{ #category : #tests }
MiModelsBrowserTest >> testUpdateForNewModelMultipleBrowsers [

	| browser2 newModel |

	self newModel: 'model1'.
	browser2 := self browserClass openForTests: self application.
	browser updateList.

	self assert: browser model entities size equals: 1.
	self assert: browser model selected isNil.

	self assert: browser2 model entities size equals: 1.
	self assert: browser2 model selected isNil.

	newModel := self newModel: 'model2'.
	browser updateForNewModel: newModel.

	self assert: browser model entities size equals: 2.
	self assert: browser model selected equals: newModel.

	self assert: browser2 model entities size equals: 2.
	self assert: browser2 model selected isNil.

	browser2 window close
]

{ #category : #tests }
MiModelsBrowserTest >> testUpdateList [

	self assertEmpty: browser model entities.

	self newModel: 'aModel'.
	browser updateList.

	self assert: browser model entities size equals: 1
]
