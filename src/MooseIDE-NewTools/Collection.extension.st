Extension { #name : #Collection }

{ #category : #'*MooseIDE-NewTools' }
Collection >> mooseInterestingEntity [

	"Method used in UI. 
		- For a group with one element, returns this element
		- For a group, returns a specialized group
		- For a model, returns the entity storage optimized for runtime."

	^ self asMooseGroup mooseInterestingEntity
]
