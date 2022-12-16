Extension { #name : #GtCoderToggleAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderToggleAction >> buildElementIn: aCoderActionsElement [
	| button |
	button := aCoderActionsElement
			newToggleForAction: self
			toggleModel: toggleModel.

	button
		when: BrToggleActivatedEvent do: activateBlock;
		when: BrToggleDeactivatedEvent do: deactivateBlock.
	^ button
]
