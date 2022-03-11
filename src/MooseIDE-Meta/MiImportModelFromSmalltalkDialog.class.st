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
		'factoryClass',
		'metamodelCheckBox',
		'invocationStrategyDroplist',
		'entitiesToImport',
		'contextCheckBoxes'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #layout }
MiImportModelFromSmalltalkDialog class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Model name: ' width: 100;
				   add: #modelNameField;
				   yourself)
		  height: self inputTextHeight;
		  add: 'Select packages: ' height: self inputTextHeight;
		  add: #packagesSelector;
		  add: #advancedSettingsButton height: self buttonHeight;
		  yourself
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog class >> fullWindowExtent [

	^ 500 @ 700
]

{ #category : #opening }
MiImportModelFromSmalltalkDialog class >> open [

	<script>
	^ self new openDialogWithSpec
]

{ #category : #specs }
MiImportModelFromSmalltalkDialog class >> title [
	^ 'Import model from Pharo image'
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog class >> windowExtent [

	^ 500 @ 400
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> addContext: aContext [

	entitiesToImport add: aContext.

	(MooseImportingContext entityDependencies at: aContext) do: [ 
		:dependency | 
		(contextCheckBoxes detect: [ :checkBox | 
			 checkBox label = dependency asString ]) state: true ]
]

{ #category : #'advanced settings' }
MiImportModelFromSmalltalkDialog >> advancedSettingsLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpGridLayout new
				   add: #metamodelCheckBox at: 1 @ 1;
				   add: #computeAttributesTypeCheckBox at: 2 @ 1;
				   add: #classesAndMetaclassesCheckBox at: 1 @ 2;
				   add: #importSubclassesCheckBox at: 2 @ 2)
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

	^ CandidateListOperator
]

{ #category : #accessing }
MiImportModelFromSmalltalkDialog >> factoryClass [

	^ factoryClass ifNil: [ factoryClass := SmalltalkMetamodelFactory ]
]

{ #category : #accessing }
MiImportModelFromSmalltalkDialog >> factoryClass: aFactoryClass [

	factoryClass := aFactoryClass
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

	^ MooseImportingContext new importMaximum
]

{ #category : #initialization }
MiImportModelFromSmalltalkDialog >> initialize [

	importingContext := MooseImportingContext new.
	entitiesToImport := MooseImportingContext entityDependencies keys
		                    asSet.
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

	metamodelCheckBox := self newCheckBox
		label: 'Use Compatibility Metamodel';
		whenActivatedDo: [ self factoryClass: SmalltalkCompatibilityMetamodelFactory ];
		whenDeactivatedDo: [ self factoryClass: SmalltalkMetamodelFactory ].
	
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

	((MooseImportingContext entityDependencies keys sort:
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

	packagesSelector := self instantiate: MiListSelector.
	packagesSelector
		initialListHeader: 'All packages in the system';
		selectedListHeader: 'Packages in your model';
		initialItems: RPackage organizer packageNames.

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

	mooseModel := self factoryClass new modelClass named: self modelName.

	MoosePharoImporterTask new
		importingContext: self importingContext;
		model: mooseModel;
		addFromPackagesNamed: self selectedPackages;
		candidateClass: self candidateClass;
		runWithProgress.

	^ mooseModel
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> removeContext: aContext [

	entitiesToImport remove: aContext.

	(MooseImportingContext entityDependencies select: [ :values | 
		 values includes: aContext ]) keysDo: [ :dependency | 
		(contextCheckBoxes detect: [ :checkBox | 
			 checkBox label = dependency asString ]) state: false ]
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> selectedPackages [

	^ packagesSelector selectedItems
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

	^ self class defaultLayout
]

{ #category : #action }
MiImportModelFromSmalltalkDialog >> validateImportForm [
	"checks that required fields are properly filled in"
	packagesSelector selectedItems ifEmpty: [ Error signal: 'Please select at least one package' ].
	modelNameField text ifEmpty: [ Error signal: 'Please name the model' ].

]
