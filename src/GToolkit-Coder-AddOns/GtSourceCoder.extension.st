Extension { #name : #GtSourceCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSourceCoder >> createLabel: aString description: description [
	^ aString asRopedText glamorousRegularFont
		, ((' ' , description) asRopedText
				glamorousCodeFont;
				foreground: Color gray;
				glamorousCodeTinySize)
]
