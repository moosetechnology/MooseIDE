Class {
	#name : #MiModelImporterFromPharo,
	#superclass : #MiPresenter,
	#instVars : [
		'packagesButton',
		'modelNameField',
		'factoryDroplist',
		'importerDroplist',
		'mergeCheckBox',
		'subclassesCheckBox',
		'typeOfAttributesCheckBox',
		'importingContext',
		'invocationStrategyDroplist',
		'packageNames',
		'contextCheckBoxes',
		'entitiesToImport',
		'modelRootBrowser'
	],
	#category : #'Midas-Meta-Presenter'
}

{ #category : #specs }
MiModelImporterFromPharo class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 8;
		add: self modelNameLayout;
		add: self packageButtonLayout height: self buttonHeight;
		add: self metamodelFactoryLayout height: self buttonHeight;
		add: #mergeCheckBox height: self labelHeight;
		add: #subclassesCheckBox height: self labelHeight;
		add: #typeOfAttributesCheckBox height: self labelHeight;
		add: self importerClassLayout height: self buttonHeight;
		add: #contextCheckBoxes;
		add: self invocationStrategyLayout height: self buttonHeight;
		yourself
]

{ #category : #specs }
MiModelImporterFromPharo class >> importerClassLayout [
	^ SpPanedLayout newHorizontal
		add: 'Importer: ';
		position: 1.5 / 5;
		add: #importerDroplist;
		yourself
]

{ #category : #specs }
MiModelImporterFromPharo class >> invocationStrategyLayout [
	^ SpBoxLayout newHorizontal
		add: 'Invocation candidates computation:';
		add: #invocationStrategyDroplist;
		yourself
]

{ #category : #specs }
MiModelImporterFromPharo class >> metamodelFactoryLayout [
	^ SpPanedLayout newHorizontal
		add: 'Metamodel factory: ';
		position: 1.5 / 5;
		add: #factoryDroplist;
		yourself
]

{ #category : #specs }
MiModelImporterFromPharo class >> modelNameLayout [
	^ SpBoxLayout newHorizontal
		add: 'Model name: ';
		add: #modelNameField;
		yourself
]

{ #category : #specs }
MiModelImporterFromPharo class >> packageButtonLayout [
	^ SpBoxLayout newHorizontal
		add: SpNullPresenter new;
		add: #packagesButton width: self buttonWidth * 2;
		add: SpNullPresenter new;
		yourself
]

{ #category : #specs }
MiModelImporterFromPharo class >> title [
	^ 'Import model from Pharo image'
]

{ #category : #updating }
MiModelImporterFromPharo >> addContext: context [
	entitiesToImport add: context.
	(MooseImportingContext entityDependencies at: context)
		do: [ :dependency | 
			(self contextCheckBoxes
				detect: [ :checkBox | checkBox label = dependency asString ])
				state: true ]
]

{ #category : #accessing }
MiModelImporterFromPharo >> contextCheckBoxes [
	^ contextCheckBoxes presenters
		reject: [ :pres | pres class == SpNullPresenter ]
]

{ #category : #accessing }
MiModelImporterFromPharo >> factoryClass [
	^ factoryDroplist selectedItem
]

{ #category : #accessing }
MiModelImporterFromPharo >> importerClass [
	^ importerDroplist selectedItem
]

{ #category : #initialization }
MiModelImporterFromPharo >> initialize [
	packageNames := OrderedCollection new.
	importingContext := MooseImportingContext new.
	entitiesToImport := MooseImportingContext entityDependencies keys
		asOrderedCollection.
	super initialize
]

{ #category : #'initialization - widgets' }
MiModelImporterFromPharo >> initializeConfigurationCheckBoxes [
	mergeCheckBox := self newCheckBox
		label: 'Merge classes and metaclasses';
		whenActivatedDo: [ importingContext mergeClassAndMetaclass ];
		whenDeactivatedDo: [ importingContext distinguishClassAndMetaclass ];
		state: true;
		yourself.
	subclassesCheckBox := self newCheckBox
		label: 'Import subclasses';
		whenActivatedDo: [ importingContext importSubclasses ];
		whenDeactivatedDo: [ importingContext doNotImportSubclasses ];
		state: true;
		yourself.
	typeOfAttributesCheckBox := self newCheckBox
		label: 'Compute type of attributes (using RoelTyper)';
		whenActivatedDo: [ importingContext computeTypeOfAttributes ];
		whenDeactivatedDo: [ importingContext doNotComputeTypeOfAttributes ];
		yourself
]

{ #category : #'initialization - widgets' }
MiModelImporterFromPharo >> initializeContextCheckBoxes [
	contextCheckBoxes := SpDynamicPresentersListBuilder new
		modelObjects:
			(MooseImportingContext entityDependencies keys
				sort: #yourself ascending);
		presenter: SpCheckBoxPresenter
			configuredAs: [ :checkBox :context | 
			checkBox
				label: context;
				state: true ];
		"9 is a magic number so we have 3 columns"
			layoutBuilder: (SpDynamicTopToBottomColumnsLayout columns: 9);
		build.
	self contextCheckBoxes
		do: [ :checkBox | 
			checkBox
				whenActivatedDo: [ self addContext: checkBox label asSymbol ];
				whenDeactivatedDo: [ self removeContext: checkBox label asSymbol ] ]
]

{ #category : #initialization }
MiModelImporterFromPharo >> initializeDialogWindow: aDialog [
	aDialog
		initialExtent: 500 @ 500;
		closeOnBackdropClick: false;
		addButton: 'Install'
			do: [ :presenter | 
			| model |
			model := self validateImportation.
			modelRootBrowser updateWith: model.
			presenter close ];
		addButton: 'Cancel' do: [ :presenter | presenter close ]
]

{ #category : #'initialization - widgets' }
MiModelImporterFromPharo >> initializeDroplists [
	factoryDroplist := self newDropList
		items: FMMetamodelFactory allFactories;
		yourself.
	importerDroplist := self newDropList
		items: {MoosePharoImporterTask};
		display: [ :item | item name ];
		yourself
]

{ #category : #'initialization - widgets' }
MiModelImporterFromPharo >> initializeInvocationStrategyDroplist [
	invocationStrategyDroplist := self newDropList
		items: AbstractCandidateListOperator allSubclasses;
		display: [ :class | class description ];
		selectItem: CandidateListOperator;
		yourself
]

{ #category : #'initialization - widgets' }
MiModelImporterFromPharo >> initializeModelNameField [
	modelNameField := self newTextInput
		text: 'MooseModel';
		yourself
]

{ #category : #'initialization - widgets' }
MiModelImporterFromPharo >> initializePackagesButton [
	packagesButton := self newButton
		label: 'Choose packages';
		action: [ (MiPackagesChoicePopup on: self) openModalWithSpec ];
		yourself
]

{ #category : #initialization }
MiModelImporterFromPharo >> initializePresenters [
	super initializePresenters.
	self initializeModelNameField.
	self initializePackagesButton.
	self initializeDroplists.
	self initializeConfigurationCheckBoxes.
	self initializeContextCheckBoxes.
	self initializeInvocationStrategyDroplist
]

{ #category : #accessing }
MiModelImporterFromPharo >> modelName [
	^ modelNameField text
]

{ #category : #accessing }
MiModelImporterFromPharo >> packages [
	^ packageNames
]

{ #category : #accessing }
MiModelImporterFromPharo >> packages: anObject [
	packageNames := anObject
]

{ #category : #updating }
MiModelImporterFromPharo >> removeContext: context [
	entitiesToImport remove: context.
	(MooseImportingContext entityDependencies
		select: [ :values | values includes: context ])
		keysDo: [ :dependency | 
			(self contextCheckBoxes
				detect: [ :checkBox | checkBox label = dependency asString ])
				state: false ]
]

{ #category : #action }
MiModelImporterFromPharo >> setImportingContext [
	entitiesToImport
		do: [ :each | importingContext perform: ('import' , each) asSymbol ]
]

{ #category : #'accessing model' }
MiModelImporterFromPharo >> setModelBeforeInitialization: aModelRootBrowser [
	modelRootBrowser := aModelRootBrowser
]

{ #category : #updating }
MiModelImporterFromPharo >> updatePackagesButton [
	packagesButton
		help:
			(String
				streamContents: [ :s | 
					packageNames
						do: [ :name | 
							s
								<< name;
								cr ] ]) trim
]

{ #category : #action }
MiModelImporterFromPharo >> validateImportation [
	| mooseModel |
	self flag: #TODO.
	"Equivalent of (wizardInformations at: #createScript) ifTrue: [ self generateScriptForPackages: selectedPackages ]"
	self setImportingContext.

	"Create model"
	mooseModel := self factoryClass new modelClass named: self modelName.

	"Set importation parameters"
	self importerClass new
		importingContext: importingContext;
		model: mooseModel;
		addFromPackagesNamed: packageNames;
		candidateClass: invocationStrategyDroplist selectedItem;
		runWithProgress.

	"Install model"
	^ mooseModel install
]
