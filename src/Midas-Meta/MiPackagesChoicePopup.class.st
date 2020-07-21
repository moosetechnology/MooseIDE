Class {
	#name : #MiPackagesChoicePopup,
	#superclass : #MiPresenter,
	#instVars : [
		'chosenPackages',
		'allPackages',
		'importer',
		'acceptButton',
		'cancelButton'
	],
	#category : #'Midas-Meta-Presenter'
}

{ #category : #accessing }
MiPackagesChoicePopup class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #allPackages;
		add: #chosenPackages;
		yourself
]

{ #category : #specs }
MiPackagesChoicePopup class >> title [
	^ 'Choose model packages'
]

{ #category : #initialization }
MiPackagesChoicePopup >> initializeDialogWindow: aDialog [
	aDialog
		closeOnBackdropClick: false;
		addButton: 'Accept'
			do: [ :presenter | 
			importer
				packages: chosenPackages items;
				updatePackagesButton.
			presenter close ];
		addButton: 'Cancel' do: [ :presenter | presenter close ]
]

{ #category : #initialization }
MiPackagesChoicePopup >> initializePresenters [
	super initializePresenters.
	allPackages := self newList
		beMultipleSelection;
		items: RPackage organizer packageNames;
		sortingBlock: #yourself ascending;
		selectItems: importer packages;
		whenSelectionChangedDo: [ chosenPackages items: allPackages selectedItems ];
		yourself.
	chosenPackages := self newList
		items: allPackages selectedItems;
		sortingBlock: #yourself ascending;
		yourself
]

{ #category : #'accessing model' }
MiPackagesChoicePopup >> setModelBeforeInitialization: anImportPresenter [
	importer := anImportPresenter
]
