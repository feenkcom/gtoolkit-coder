Extension { #name : #GtCoderActivatableAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderActivatableAction >> buildElementIn: aCoderActionsElement [
	| aButton |

	aButton := aCoderActionsElement newButtonForAction: self.
	aButton enabled: (enabledBlock cull: aCoderActionsElement coderViewModel).
	
	updateAnnouncement ifNotNil: [
		aCoderActionsElement coderViewModel announcerUIModel weak
			when: updateAnnouncement send: #enabled: to: aButton ].
	
	^ aButton
]
