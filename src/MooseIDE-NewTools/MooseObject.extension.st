Extension { #name : #MooseObject }

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> customNavigationItems [

	^ {  }
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject class >> inspectorToString [
	^ name
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> miInspectionNavigation: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Navigation'>
	^ aBuilder instantiate: MiMetaNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> miMetaNavigationItems [

	^ self mooseDescription allComplexProperties
		  collect: [ :property |
			  | value |
			  value := self propertyNamed: property name ifAbsent: [ nil ].
			  value isCollection ifTrue: [ value := value asMooseGroup ].
			  property name -> value ]
		  thenReject: [ :assoc |
			  assoc value isNil or: [
				  assoc value isCollection and: [ assoc value isEmpty ] ] ]
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> navigationItemsFromPragmas [

	| pragmaValueAssociations |
	"returns associations in form name->object for navigation entities obtained from
	the pragma #navigation:"
	pragmaValueAssociations := (self mooseInterestingEntity
		                            navigationPragmas sorted:
		                            [ :pragma |
		                            pragma argumentNamed: #navigation: ]
			                            ascending) collect: [ :pragma |
		                           pragma inspectorToString
		                           -> pragma methodSelector ].

	"filter out nils and empty collections, sort"
	^ pragmaValueAssociations reject: [ :entity | entity isNil ]
]
