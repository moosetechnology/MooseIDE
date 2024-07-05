"
Dialog used to import models from Pharo
"
Class {
	#name : #MiImportModelFromSmalltalkDialog,
	#superclass : #MiImportModelDialog,
	#instVars : [
		'modelNameField',
		'packagesSelector',
		'advancedSettingsButton',
		'importingContext',
		'classesAndMetaclassesCheckBox',
		'importSubclassesCheckBox',
		'computeAttributesTypeCheckBox',
		'invocationStrategyDroplist',
		'entitiesToImport',
		'contextCheckBoxes'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #accessing }
MiImportModelFromSmalltalkDialog class >> fullWindowExtent [

	^ 500 @ 700
]

{ #category : #opening }
MiImportModelFromSmalltalkDialog class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiImportModelFromSmalltalkDialog class >> title [
	^ 'Import model from Pharo image'
]

{ #category : #accessing }
MiImportModelFromSmalltalkDialog class >> windowExtent [

	^ 500 @ 400
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> addContext: aContext [

	entitiesToImport add: aContext.

	(FamixStImporterContext entityDependencies at: aContext) do: [ 
		:dependency | 
		(contextCheckBoxes detect: [ :checkBox | 
			 checkBox label = dependency asString ]) state: true ]
]

{ #category : #'advanced settings' }
MiImportModelFromSmalltalkDialog >> advancedSettingsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpGridLayout new
				   add: #computeAttributesTypeCheckBox at: 2 @ 1;
				   add: #classesAndMetaclassesCheckBox at: 1 @ 1;
				   add: #importSubclassesCheckBox at: 1 @ 2)
		  height: 80;
		  add: 'Select context to import: '
		  height: self class inputTextHeight;
		  add: self initializeEntitiesCheckBoxes;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Invocation candidates computation: ';
				   add: #invocationStrategyDroplist;
				   yourself)
		  height: self class buttonHeight;
		  yourself
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> candidateClass [

	^ invocationStrategyDroplist selectedItem
]

{ #category : #layout }
MiImportModelFromSmalltalkDialog >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Model name: ' width: 100;
				   add: modelNameField;
				   yourself)
		  height: self class inputTextHeight;
		  add: 'Select packages: ' height: self class inputTextHeight;
		  add: packagesSelector;
		  add: advancedSettingsButton height: self class buttonHeight;
		  yourself
]

{ #category : #'advanced settings' }
MiImportModelFromSmalltalkDialog >> hideAdvancedSettings [

	advancedSettingsButton icon: (self iconNamed: #arrowDown).
	self withWindowDo: [ :window | 
		window extent: self class windowExtent ].
	self layout: self simpleLayout
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> importingContext [

	^ importingContext
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initialize [

	importingContext := FamixStImporterContext new.
	entitiesToImport := FamixStImporterContext entityDependencies keys asSet.
	contextCheckBoxes := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initializeAdvancedSettingsPresenters [

	self initializeConfigurationCheckBoxes.
	self initializeInvocationStrategyDroplist
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initializeConfigurationCheckBoxes [

	classesAndMetaclassesCheckBox := self newCheckBox
		label: 'Merge classes and metaclasses';
		whenActivatedDo: [ importingContext mergeClassAndMetaclass ];
		whenDeactivatedDo: [ importingContext distinguishClassAndMetaclass ];
		state: true;
		yourself.
	
	importSubclassesCheckBox := self newCheckBox
		label: 'Import subclasses';
		whenActivatedDo: [ importingContext importSubclasses ];
		whenDeactivatedDo: [ importingContext doNotImportSubclasses ];
		state: true;
		yourself.

	computeAttributesTypeCheckBox := self newCheckBox
		label: 'Compute attributes type (RoelTyper)';
		whenActivatedDo: [ importingContext computeTypeOfAttributes ];
		whenDeactivatedDo: [ importingContext doNotComputeTypeOfAttributes ];
		yourself
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initializeEntitiesCheckBoxes [

	| checkBoxesLayout |
	checkBoxesLayout := SpBoxLayout newLeftToRight.

	((FamixStImporterContext entityDependencies keys sort:
		  #yourself ascending) groupsOf: 5) do: [ :group | 
		| subLayout |
		subLayout := SpBoxLayout newVertical.
		group do: [ :entityType | 
			| checkBox |
			checkBox := SpCheckBoxPresenter new
				            label: entityType;
				            state: true;
				            whenActivatedDo: [ self addContext: entityType ];
				            whenDeactivatedDo: [ self removeContext: entityType ];
				            yourself.
			subLayout add: checkBox.
			contextCheckBoxes add: checkBox ].
		checkBoxesLayout add: subLayout ].
	^ checkBoxesLayout
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initializeInvocationStrategyDroplist [

	invocationStrategyDroplist := self newDropList
			items: AbstractCandidateListOperator allSubclasses;
			display: [ :class | class description ];
			selectItem: CandidateListOperator;
			yourself
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initializePresenters [

	modelNameField := self newTextInput text: 'MooseModel'.

	packagesSelector := self instantiate: SpChooserPresenter.
	packagesSelector sourceItems: self packageOrganizer packageNames.

	advancedSettingsButton := self newToggleButton
		label: 'Advanced settings';
		icon: (self iconNamed: #arrowDown);
		whenActivatedDo: [ self showAdvancedSettings ];
		whenDeactivatedDo: [ self hideAdvancedSettings ].

	self initializeAdvancedSettingsPresenters
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> modelName [

	^ modelNameField text
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> privateImportModel [

	| mooseModel |
	self setImportingContext.

	FamixStPharoImporterTask new
		importingContext: self importingContext;
		model: (mooseModel := FamixStModel named: self modelName);
		addFromPackagesNamed: self selectedPackages;
		candidateClass: self candidateClass;
		runWithProgress.

	^ mooseModel
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> removeContext: aContext [

	entitiesToImport remove: aContext.

	(FamixStImporterContext entityDependencies select: [ :values | 
		 values includes: aContext ]) keysDo: [ :dependency | 
		(contextCheckBoxes detect: [ :checkBox | 
			 checkBox label = dependency asString ]) state: false ]
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> selectedPackages [

	^ packagesSelector chosenItems
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> setImportingContext [

	entitiesToImport do: [ :each | 
		importingContext perform: ('import' , each) asSymbol ]
]

{ #category : #'advanced settings' }
MiImportModelFromSmalltalkDialog >> showAdvancedSettings [

	advancedSettingsButton icon: (self iconNamed: #arrowUp).
	self withWindowDo: [ :window | 
		window extent: self class fullWindowExtent ].
	self layout: (self simpleLayout
			 add: self advancedSettingsLayout;
			 yourself)
]

{ #category : #'advanced settings' }
MiImportModelFromSmalltalkDialog >> simpleLayout [

	^ SpBoxLayout newVertical
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> validateImportForm [

	"checks that required fields are properly filled in"

	packagesSelector chosenItems ifEmpty: [ Error signal: 'Please select at least one package' ].
	modelNameField text ifEmpty: [ Error signal: 'Please name the model' ]
]
