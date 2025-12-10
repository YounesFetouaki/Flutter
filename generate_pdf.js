const PDFDocument = require('pdfkit');
const fs = require('fs');

const doc = new PDFDocument();
doc.pipe(fs.createWriteStream('rapport_atelier_2.pdf'));

doc.fontSize(25).text('Rapport Atelier 2', { align: 'center' });
doc.moveDown();
doc.fontSize(14).text('Un document PDF contenant des captures d\'écran et une description détaillée des fonctionnalités implémentées');
doc.moveDown();

doc.fontSize(16).text('Fonctionnalités implémentées :', { underline: true });
doc.list([
    'Validation du formulaire d\'ajout (champs requis, format prix, URL valide).',
    'Prévisualisation de l\'image avant ajout.',
    'Amélioration de l\'UX : clavier adapté, navigation par "Suivant".',
    'Barre de notification (SnackBar) lors de la suppression avec option "Annuler".',
]);

doc.addPage();
doc.fontSize(20).text('Ecran d\'accueil (Liste)', { align: 'center' });
doc.moveDown();
doc.image('screenshots/home.png', {
    fit: [500, 400],
    align: 'center',
    valign: 'center'
});

doc.addPage();
doc.fontSize(20).text('Ecran d\'ajout (Validation & Preview)', { align: 'center' });
doc.moveDown();
doc.image('screenshots/add.png', {
    fit: [500, 400],
    align: 'center',
    valign: 'center'
});

doc.end();
