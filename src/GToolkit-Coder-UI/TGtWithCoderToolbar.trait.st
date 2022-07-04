Trait {
	#name : #TGtWithCoderToolbar,
	#instVars : [
		'toolbarElement'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #accessing }
TGtWithCoderToolbar >> initializeToolbarElement [
	toolbarElement := GtCoderToolbarElement new
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ]
]

{ #category : #accessing }
TGtWithCoderToolbar >> navigationModelForToolbar: aNavigationModel [
	self toolbarElement navigationModel: aNavigationModel
]

{ #category : #accessing }
TGtWithCoderToolbar >> toolbarElement [
	^ toolbarElement
]
