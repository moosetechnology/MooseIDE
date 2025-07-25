Class {
	#name : #MiAssociationTypesSettingPresenter,
	#superclass : #MiAbstractSelectableSettingPresenter,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiAssociationTypesSettingPresenter class >> help [

	^ 'Select dependencies you want to see in the visualization'
]

{ #category : #accessing }
MiAssociationTypesSettingPresenter class >> label [

	^ 'Show dependencies: '
]

{ #category : #'api - selection' }
MiAssociationTypesSettingPresenter >> allItems [

	^ memento availableAssociationTypes
]

{ #category : #'api - selection' }
MiAssociationTypesSettingPresenter >> selectAll [

	memento associationTypes: memento availableAssociationTypes
]

{ #category : #'api - selection' }
MiAssociationTypesSettingPresenter >> selectItem: anAssociationType [

	memento associationTypes add: anAssociationType
]

{ #category : #'api - selection' }
MiAssociationTypesSettingPresenter >> selectNone [

	memento associationTypes: OrderedCollection new
]

{ #category : #'api - selection' }
MiAssociationTypesSettingPresenter >> selectedItems [

	^ memento associationTypes
]

{ #category : #'api - selection' }
MiAssociationTypesSettingPresenter >> unselectItem: anAssociationType [

	memento associationTypes remove: anAssociationType
]
