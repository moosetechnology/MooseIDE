Extension { #name : 'MooseObject' }

{ #category : '*MooseIDE-NewTools' }
MooseObject >> customNavigationItems [

	^ {  }
]

{ #category : '*MooseIDE-NewTools' }
MooseObject class >> inspectorToString [
	^ name
]

{ #category : '*MooseIDE-NewTools' }
MooseObject >> miInspectionNavigation: aBuilder [

	<inspectorPresentationOrder: 1 title: 'Navigation'>
	^ aBuilder instantiate: MiNavigationInspectionTab on: self
]

{ #category : '*MooseIDE-NewTools' }
MooseObject >> miMetaNavigationItems [
	^ self mooseDescription allComplexProperties
		  collect: [ :property |
				  | value |
				  value := self valueOfFameProperty: property.
				 value := self valueOfPropertyForInspector: value.
				  value isCollection ifTrue: [ value := value asMooseGroup ].
				  property name -> value ]
		  thenReject: [ :assoc |
				  assoc value isNil or: [
					  assoc value isCollection and: [ assoc value isEmpty ] ] ]
]

{ #category : '*MooseIDE-NewTools' }
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

{ #category : '*MooseIDE-NewTools' }
MooseObject >> valueOfPropertyForInspector: value [
	
	value isCollection ifTrue: [ 
		^ value collect: [ :each | self valueOfPropertyForInspector: each ]
		 ].
	value isAssociation ifFalse: [ ^ value ].
	^ value source = self ifTrue: [ value target ] ifFalse: [ value source ]
]
