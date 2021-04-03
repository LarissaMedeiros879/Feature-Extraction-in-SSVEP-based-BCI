clear all
close all

H = [];
vetortotal = [];
sessoes = 16;
for f = 1:sessoes
  if f<9
    frequencia = '12_Hz';
    sessao = num2str(f);
    rotulo = 1;
  else
    frequencia = '15_Hz';
    sessao = num2str(f-8);
    rotulo = -1;
  end
  load (['ssvep_',frequencia,'_training_subject_subject1_session_',sessao,'.mat']);








dados = storageDataAcquirement';

plot(dados(1,:));

sinalmedio = mean(dados);
canais = 16;
for j = 1:canais
  dados(j,:) = dados(j,:) - sinalmedio;
  end
  
matrizdados = [];
vetorrotulos = [];

n_janela = 12;
a = n_janela;  
  for k = 1:a
    vetoratributos = [];
    for l = 1:sessoes
      
      janela = dados(l,(k-1)*256+1:(k+(12-a))*256);
      espectro = fft(janela, 5120);
      atributos = [sum(abs(espectro(230:250))), sum(abs(espectro(290:310)))];
      vetoratributos = [vetoratributos,atributos];
    end
    matrizdados = [matrizdados;vetoratributos];
    vetorrotulos = [vetorrotulos;rotulo];
  end
  H = [H;matrizdados];
  vetortotal = [vetortotal;vetorrotulos];
  end
  x = a*sessoes;
  H = [H,ones(x,1)];
 
  ntreinamento = fix(0.7*x);
  aleatorio = randperm(x);
  indicetreinamento = aleatorio(1:ntreinamento);
  indiceteste = aleatorio(ntreinamento+1:end);
  vetortreinamento = vetortotal(indicetreinamento);
  vetorteste = vetortotal(indiceteste);
  Htreinamento = H(indicetreinamento,:);
  Hteste = H(indiceteste,:);

  w = pinv(Htreinamento)*vetortreinamento;
  saidatreinamento = Htreinamento*w;
  saidadecisaotr = sign(saidatreinamento);
  vetorerrotr = vetortreinamento - saidadecisaotr;
  taxadeerrotr = mean(abs(vetorerrotr)/2);
  saidateste = Hteste*w;
  saidadecisaote = sign(saidateste);
  vetorerrote = vetorteste - saidadecisaote;
  taxadeerrote = mean(abs(vetorerrote)/2);
  taxate = num2str(taxadeerrote);
  taxate = strrep(taxate,'.', ',');
  taxatr = num2str(taxadeerrotr);
  taxatr = strrep(taxatr,'.', ',');
