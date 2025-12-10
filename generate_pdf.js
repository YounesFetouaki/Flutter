const PDFDocument = require('pdfkit');
const fs = require('fs');

const doc = new PDFDocument();
doc.pipe(fs.createWriteStream('rapport_atelier_1.pdf'));

doc.fontSize(25).text('Rapport Atelier 1', { align: 'center' });
doc.moveDown();
doc.fontSize(14).text('Un document PDF contenant des captures d\'écran et une description détaillée des fonctionnalités implémentées');
doc.moveDown();

doc.fontSize(16).text('Fonctionnalités implémentées :', { underline: true });
doc.list([
  'Affichage de la liste des produits (nom, description, prix, image).',
  'Suppression de produits.',
  'Formulaire d\'ajout de produit (champs : titre, description, prix, URL image).',
  'Navigation basique entre la liste et le formulaire.',
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
doc.fontSize(20).text('Ecran d\'ajout de produit', { align: 'center' });
doc.moveDown();
doc.image('screenshots/add.png', {
  fit: [500, 400],
  align: 'center',
  valign: 'center'
});

doc.end();
