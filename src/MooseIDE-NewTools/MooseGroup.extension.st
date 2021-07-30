Extension { #name : #MooseGroup }

{ #category : #'*MooseIDE-NewTools' }
MooseGroup >> mooseInterestingEntity [

	"Method used in UI. 
		- For a group with one element, returns this element
		- For a group, returns a specialized group
		- For a model, returns the entity storage optimized for runtime."

	^ self size = 1
		  ifTrue: [ self first mooseInterestingEntity ]
		  ifFalse: [ self specialize ]
]
