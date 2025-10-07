Trait {
	#name : #TGtCoderNavigationWithContextMenu,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'private - context menu' }
TGtCoderNavigationWithContextMenu >> createLabel: aString description: description [
	^ aString asRopedText glamorousRegularFont
		, ((' ' , description) asRopedText
				glamorousCodeFont;
				foreground: Color gray;
				glamorousCodeTinySize)
]
