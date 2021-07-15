Extension { #name : #Object }

{ #category : #'*Midas-NewTools' }
Object >> inspectorToString [
	^ self printString
]

{ #category : #'*Midas-NewTools' }
Object >> isNAryQuery [

	^ false
]

{ #category : #'*Midas-NewTools' }
Object >> mooseInterestingEntity [

	"Method used in UI. 
		- For a group with one element, returns this element
		- For a group, returns a specialized group
		- For a model, returns the entity storage optimized for runtime."

	^ self
]
