"
A dark diff palette with charcoal editor surfaces, muted Ant Design red and green change regions, and stronger inline highlights. Focus uses BrGlamorousColors primaryBorderColor.
"
Class {
	#name : #GtDiffElementDarkTheme,
	#superclass : #GtDiffElementTheme,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #defaults }
GtDiffElementDarkTheme >> defaultLabelForegroundColor [
	^ Color fromHexString: '8C8C8C'
]

{ #category : #initialization }
GtDiffElementDarkTheme >> initializeConstants [
	super initializeConstants.
	self constantAt: #editorBackgroundColor put: (Color fromHexString: '141414').
	self
		constantAt: #deletedLineBackgroundColor
		put: (Color fromHexString: '431418').
	self
		constantAt: #deletedTextBackgroundColor
		put: (Color fromHexString: '791A1F').
	self constantAt: #addedLineBackgroundColor put: (Color fromHexString: '1D3712').
	self constantAt: #addedTextBackgroundColor put: (Color fromHexString: '306317').
	self
		constantAt: #unchangedSideBackgroundColor
		put: (Color fromHexString: '262626').
	self constantAt: #connectorBackgroundColor put: (Color fromHexString: '1F1F1F').
	self constantAt: #borderColor put: (Color fromHexString: '434343').
	self constantAt: #editorBorderColor put: (Color fromHexString: '303030')
]
