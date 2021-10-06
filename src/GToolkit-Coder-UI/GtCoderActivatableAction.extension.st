Extension { #name : #GtCoderActivatableAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderActivatableAction >> buildElementIn: aCoderActionsElement [
	| aButton |

	aButton := aCoderActionsElement newButtonForAction: self.
	aButton enabled: (enabledBlock cull: aCoderActionsElement coderUIModel).
	
	updateAnnouncement ifNotNil: [
		aCoderActionsElement coderUIModel announcerUIModel weak
			when: updateAnnouncement send: #enabled: to: aButton ].
	
	^ aButton
]
