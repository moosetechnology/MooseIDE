Extension { #name : #Object }

{ #category : #'*MooseIDE-NewTools' }
Object >> inspectorToString [
	^ self printString
]

{ #category : #'*MooseIDE-NewTools' }
Object >> miMetaNavigationItems [
	"Method used in UI. There is no navigation items for non-Moose objects"

	^ {  }
]

{ #category : #'*MooseIDE-NewTools' }
Object >> mooseInterestingEntity [

	"Method used in UI. 
		- For a group with one element, returns this element
		- For a group, returns a specialized group
		- For a model, returns the entity storage optimized for runtime."

	^ self
]
