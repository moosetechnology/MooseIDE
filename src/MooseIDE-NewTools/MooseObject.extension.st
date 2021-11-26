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
MooseObject >> miFameInspectorExtension [

	<inspectorPresentationOrder: 3 title: 'Fame'>
	^ MiFameExtension on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> miNavigationInspectorExtension [

	<inspectorPresentationOrder: 0 title: 'Navigation'>
	^ MiNavigationBrowser on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> miPropertiesInspectorExtension [

	<inspectorPresentationOrder: 2 title: 'Moose Properties'>
	^ MiPropertyExtension on: self
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> navigationItemsFromAttributes [

	| entity assocs attrs |
	"returns associations in form name->object for navigation entities obtained from
	the the meta-model attributes of the item"
	entity := self mooseInterestingEntity.
	attrs := entity allDeclaredProperties reject: [ :attribute | 
		         attribute type isPrimitive ].
	assocs := attrs collect: [ :anAttribute | 
		          anAttribute name
		          -> (entity perform: anAttribute compiledMethod selector) ].

	"filter out nils and empty collections, sort"
	^ (assocs reject: [ :association | 
		   association value isNil or: [ 
			   association value isCollection and: [ association value isEmpty ] ] ]) 
		  sorted:
			  [ :a | 
			  a key formatForNavigationPresentation asLowercase asString ]
				  ascending
]

{ #category : #'*MooseIDE-NewTools' }
MooseObject >> navigationItemsFromPragmas [

	| pragmaValueAssociations |
	"returns associations in form name->object for navigation entities obtained from
	the pragma #navigation:"
	pragmaValueAssociations := (self mooseInterestingEntity
		                            navigationPragmas sorted:
		                            [ :pragma | 
		                            pragma argumentNamed: #navigation ]
			                            ascending) collect: [ :pragma | 
		                           pragma inspectorToString
		                           ->
			                           ([ 
			                            self mooseInterestingEntity perform:
				                            pragma methodSelector ] onErrorDo: [ 
				                            nil ]) mooseInterestingEntity ].

	"filter out nils and empty collections, sort"
	^ pragmaValueAssociations reject: [ :entity | 
		  entity isNil or: [ entity isCollection and: [ entity isEmpty ] ] ]
]
