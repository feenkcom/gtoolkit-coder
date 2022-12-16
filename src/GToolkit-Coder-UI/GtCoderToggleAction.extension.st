Extension { #name : #GtCoderToggleAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderToggleAction >> buildElementIn: aCoderActionsElement [
	| button |
	button := aCoderActionsElement newToggleForAction: self.
	toggleModel
		when: BrToggleActivatedEvent do: [ :evt | button activate ];
		when: BrToggleDeactivatedEvent do: [ :evt | button deactivate ].

	button
		activated: toggleModel isActivated;
		when: BrToggleActivatedEvent
			do: [ :evt | 
				toggleModel activate.
				activateBlock value: evt ];
		when: BrToggleDeactivatedEvent
			do: [ :evt | 
				toggleModel deactivate.
				deactivateBlock value: evt ].
	^ button
]
