Class {
	#name : 'MiAssociationTypesSettingPresenter',
	#superclass : 'MiAbstractSelectableSettingPresenter',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiAssociationTypesSettingPresenter class >> help [

	^ 'Select dependencies you want to see in the visualization'
]

{ #category : 'accessing' }
MiAssociationTypesSettingPresenter class >> label [

	^ 'Show dependencies: '
]

{ #category : 'api - selection' }
MiAssociationTypesSettingPresenter >> allItems [

	^ configuration availableAssociationTypes
]

{ #category : 'api - selection' }
MiAssociationTypesSettingPresenter >> selectAll [

	configuration associationTypes: configuration availableAssociationTypes
]

{ #category : 'api - selection' }
MiAssociationTypesSettingPresenter >> selectItem: anAssociationType [

	configuration associationTypes add: anAssociationType
]

{ #category : 'api - selection' }
MiAssociationTypesSettingPresenter >> selectNone [

	configuration associationTypes: OrderedCollection new
]

{ #category : 'api - selection' }
MiAssociationTypesSettingPresenter >> selectedItems [

	^ configuration associationTypes
]

{ #category : 'api - selection' }
MiAssociationTypesSettingPresenter >> unselectItem: anAssociationType [

	configuration associationTypes remove: anAssociationType
]
