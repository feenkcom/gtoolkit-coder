Class {
	#name : #GtExpandedCoderElementWithRustTextEditorStencil,
	#superclass : #GtCoderElementStencil,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'api - instantiation' }
GtExpandedCoderElementWithRustTextEditorStencil >> defaultElement [
	<return: #BlElement>
	^ GtSourceCoderExpandedContentElement new
		initializeEditorElement: (GtTextEditorElement new
			defaultFontName: 'Source Code Pro';
			defaultFontSize: 14;
			defaultForeground: Color black;
			in: [ :anEditor | anEditor privateEditorHandle enableInMemoryCommandsRecorder ];
			yourself)
]
