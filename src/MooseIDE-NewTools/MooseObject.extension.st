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
